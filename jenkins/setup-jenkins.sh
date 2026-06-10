#!/usr/bin/env bash
# One-time local Jenkins setup for AutomationBDD
set -euo pipefail

JENKINS_HOME="${JENKINS_HOME:-$HOME/.jenkins}"
JENKINS_URL="${JENKINS_URL:-http://127.0.0.1:8080}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_PASS="${ADMIN_PASS:-admin123}"
REPO_URL="${REPO_URL:-https://github.com/viraj411/AutomationBDD.git}"

echo "==> Jenkins home: $JENKINS_HOME"

# Skip setup wizard on next start
mkdir -p "$JENKINS_HOME/init.groovy.d"
JENKINS_VERSION=$(java -jar /opt/homebrew/opt/jenkins-lts/libexec/jenkins.war --version 2>/dev/null | tail -1 || echo "2.555.2")
echo "$JENKINS_VERSION" > "$JENKINS_HOME/jenkins.install.InstallUtil.lastExecVersion"

cat > "$JENKINS_HOME/init.groovy.d/basic-security.groovy" <<'GROOVY'
import jenkins.model.*
import hudson.security.*

def jenkins = Jenkins.getInstance()
if (jenkins.getSecurityRealm() == null || jenkins.getSecurityRealm().getClass().getName().contains('None')) {
    def realm = new HudsonPrivateSecurityRealm(false)
    realm.createAccount('admin', 'admin123')
    jenkins.setSecurityRealm(realm)
    jenkins.setAuthorizationStrategy(new FullControlOnceLoggedInAuthorizationStrategy())
    jenkins.save()
    println 'Created admin user'
}
GROOVY

# Install plugins
cat > /tmp/jenkins-plugins.txt <<'PLUGINS'
workflow-aggregator
git
junit
allure-jenkins-plugin
timestamper
PLUGINS

echo "==> Installing Jenkins plugins (may take a few minutes)..."
if command -v jenkins-plugin-cli >/dev/null 2>&1; then
  JENKINS_URL="$JENKINS_URL" jenkins-plugin-cli --plugin-file /tmp/jenkins-plugins.txt
else
  java -jar /opt/homebrew/opt/jenkins-lts/libexec/jenkins.war --pluginInstallLocation "$JENKINS_HOME/plugins" \
    --plugin-file /tmp/jenkins-plugins.txt 2>/dev/null || \
  echo "Plugin install via CLI skipped — install manually if needed."
fi

echo "==> Restarting Jenkins..."
brew services restart jenkins-lts
sleep 20

until curl -sf "$JENKINS_URL/login" >/dev/null; do
  echo "Waiting for Jenkins..."
  sleep 5
done

echo "==> Downloading Jenkins CLI..."
curl -fsSL "$JENKINS_URL/jnlpJars/jenkins-cli.jar" -o /tmp/jenkins-cli.jar

echo "==> Creating AutomationBDD pipeline job..."
INITIAL_PASS=$(cat "$JENKINS_HOME/secrets/initialAdminPassword" 2>/dev/null || echo "$ADMIN_PASS")
java -jar /tmp/jenkins-cli.jar -s "$JENKINS_URL/" -auth "${ADMIN_USER}:${INITIAL_PASS}" groovy = <<GROOVY
if (Jenkins.instance.getItem('AutomationBDD') == null) {
    def jobXml = '''<?xml version='1.1' encoding='UTF-8'?>
<flow-definition plugin="workflow-job">
  <description>AutomationBDD — Cucumber + Selenium BDD tests</description>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps">
    <scm class="hudson.plugins.git.GitSCM" plugin="git">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>${REPO_URL}</url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/main</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="empty-list"/>
      <extensions/>
    </scm>
    <scriptPath>Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <disabled>false</disabled>
</flow-definition>'''
    Jenkins.instance.createProjectFromXML('AutomationBDD', new ByteArrayInputStream(jobXml.getBytes('UTF-8')))
    println 'Job AutomationBDD created'
} else {
    println 'Job AutomationBDD already exists'
}
GROOVY

echo "==> Triggering first build..."
java -jar /tmp/jenkins-cli.jar -s "$JENKINS_URL/" -auth "${ADMIN_USER}:${INITIAL_PASS}" build AutomationBDD -s -v

echo ""
echo "============================================"
echo " Jenkins is ready!"
echo " URL:      $JENKINS_URL"
echo " User:     $ADMIN_USER"
echo " Password: $ADMIN_PASS"
echo " Job:      $JENKINS_URL/job/AutomationBDD/"
echo "============================================"
