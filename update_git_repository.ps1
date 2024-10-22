
$gitDomain = "https://github.com/";
$branch = "origin"; # upstream
$thisFolder = Split-Path -Path (Get-Location) -Leaf;
$getUser = git config --get user.name;

$repositoryURL = "$gitDomain$getUser/$thisFolder.git";
# $repositoryURL = git config --get remote.origin.url;

Clear-Host;

Write-Host "============================ Atualizar repositório no Github ============================" -ForegroundColor Green; 
Write-Host "   Usuário: " -ForegroundColor Green -NoNewline; Write-Host $getUser -ForegroundColor Yellow;
Write-Host "   Repositório: " -ForegroundColor Green -NoNewline; Write-Host $repositoryURL -ForegroundColor Yellow;
Write-Host "=========================================================================================" -ForegroundColor Green; 

# :::::::::::::::::::::::::::: upgrade repository ::::::::::::::::::::::::::::::
git add .
git commit -m $thisFolder
git pull $branch main
git push -u $branch main

# :::::::::::::::::::::::::::: first commit in an existing repository ::::::::::::::::::::::::::::::
# git init
# git add .
# git commit -m $thisFolder
# git branch -M main
# git remote add $branch $repositoryURL
# git push -u $branch main



# ------------------ Outros comandos -------------------

# Imprimir URLs com os métodos origin: git remote -v

# Imprimir URL origin: git config --get remote.origin.url

# Redefinir a URL origin: git remote set-url origin https://github.com/userName/RepositoryName.git