from string import Template
from os import system
import subprocess
 
installCommandTemplate = Template("source ~/.nvm/nvm.sh && nvm install ${new} --reinstall-packages-from=${old}")
uninstallCommandTemplate = Template("source ~/.nvm/nvm.sh && nvm uninstall ${old}")
currentVersionsCommand = "source ~/.nvm/nvm.sh && nvm ls --no-alias --no-colors"
availableVersionsCommand = "source ~/.nvm/nvm.sh && nvm ls-remote --lts --no-colors | grep 'Latest'"

currentVersions = []
availableVersions = []

proc = subprocess.Popen(["/bin/bash", "-i", "-c", currentVersionsCommand], stdout=subprocess.PIPE, stdin=None)

out, err = proc.communicate()
rawVersionList = out.decode("utf-8").strip().split("\n")

#print("Current versions:")

for rawVersion in rawVersionList:
	version = rawVersion.replace("->", "").replace("*", "").strip()
	currentVersions.append(version)
	#print(version)


proc = subprocess.Popen(["/bin/bash", "-i", "-c", availableVersionsCommand], stdout=subprocess.PIPE, stdin=None)

out, err = proc.communicate()
rawVersionList = out.decode("utf-8").strip().split("\n")

#print("Available versions:")

for rawVersion in rawVersionList:
	foundVersion = rawVersion.replace("->", "").replace("*", "").strip()
	start = foundVersion.find("(")

	version = foundVersion

	if start != -1:
  		version = foundVersion[0:start].strip()

	#print(version)
	availableVersions.append(version)

proc = subprocess.Popen(["/bin/zsh", "-c", "source ~/.nvm/nvm.sh && nvm unload"])
proc.wait()

print("echo '========================'")
print("echo '== CHECKING INSTALLED =='")
print("echo '========================'")

for version in currentVersions:
	if version in availableVersions:
		print("echo '%s is already latest LTS'" %version)
		continue

	major = version.split(".")[0]
	newVersionList = [x for x in availableVersions if x.startswith(major)]

	if not newVersionList:
		print("echo '%s is not an LTS'" %version)
		continue
	else:
		print("echo '%s is out of date'" %version)

	newVersion = newVersionList[0]

	print(installCommandTemplate.substitute(new=newVersion, old=version))
	print("echo 'INSTALLED %s'" %newVersion)
	
	print(uninstallCommandTemplate.substitute(old=version))
	print("echo 'UNINSTALLED %s'" %version)
