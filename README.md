# Packer
vmWare templates with Hashicorp Packer

## Usage on Windows

**Prerequisites**

All prerequisites are installed with the help of **Chocolatey**, to install **Chocolatey** excute the following commands:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
ku
```

**Packer** (to be able to use packer...):

```powershell
choco install packer
```

**Vault** (to be able to test Vault, not needed for **Packer** to work though...):

```powershell
choco install vault
```

**VMware Workstation Player** (needed for VMware driver):

```powershell
choco install vmware-workstation-player
```

**To use Packer**

Go to the local directory containing the Packer JSON file:

```powershell
cd C:\my_cloned_projects\packer
```

Define **Vault** variables as env variables:

```powershell
$url='https://vault.domain/v1/auth/approle/login'
$form= @{
    role_id = '46a2a2cc-dbc0-21ba-e978-acd8382d54c4'
    secret_id = '4f6f6516-1fd6-0306-3adc-27f8c523e1ca'
    }

$response=Invoke-RestMethod -Uri $url -Method Post -Body $form | Select-Object -Property auth
$token=($response[0].auth | Select-Object client_token | ft -HideTableHeaders | Out-String).Trim()
$env:VAULT_TOKEN=$token
$env:VAULT_ADDR="https://vault.domain"
$env:VAULT_SKIP_VERIFY="true"
```

Read a secret to test **Vault** is working:

```powershell
vault read secret/data/config/ssh_root
```

Launch **Packer** to make the build:
```powershell
packer build --force rhel-vmware.json
```

**Create a KickStart ISO on Windows**

After trying several methods, the best option seem to use the program CDBurnerXP, to install:

```powershell
choco install cdburnerxp
```

- KS.CFG name and extention should be all caps. (If you are using Autoyast, autoinst.xml should have the same name as in the boot_command of the JSON file.)

- Title of the ISO should be "OEMDRV".

- File system should be ISO9660.
