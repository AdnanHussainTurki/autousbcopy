# AutoUSBCopy

AutoUSBCopy aims to solve the age old problem of automatic dumping the SD-card to a bulk storage system like a NAS or Cloud Storage. AutoUSBCopy designed to work on Windows but uses popular tool called `rsync` to ssh into the destination system and copy the files.

## Prerequisites

- Cygwin must be installed with the following packages
  - rsync
  - ssh
- Cygwin terminal must be able to connect to the destination system via SSH using the SSH keys (without password). This can be tested by running the following command in the Cygwin terminal
  - `ssh <username>@<ip-address>`

## Installation

We can setup the AutoUSBCopy to be run automatically on system startup as following:

- First and formost, don't forget to star this repo, it is useful to you 😅

- Clone/download this repo to your local system.

```
git clone adnanhussainturki/autousbcopy
```

- Copy the file `autocopy.ps1` to the windows startup folder. The path startup folder can be found by entering `shell:startup` in `Run` window (`Win + R`). Typically the path to startup folder looks like this:

```
C:\Users\USERNAME\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
```

- Open the file `autocopy.ps1` in a text editory and make changes in the variable defined at the top of the script.

  - `$minSizeGB` defines the lowest size of the drive that will be considered for copying. This is to avoid copying of small drives like USB sticks.
  - `$maxSizeGB` defines the highest size of the drive that will be considered for copying. This is to avoid copying of large drives like external hard drives.
  - `$usernameWithHost` defines the username and host of the destination system. This is used to ssh into the destination system.
  - `$cygwinPath` defines the path to the cygwin installation. This is used to run the `rsync` command.
  - `$waitTimeInSeconds` defines the time to wait before checking for new drives. This is to avoid unnecessary CPU usage.

- Now mere restarting the system should run the script automatically and allow automatic copying of the SD-card.

## Buy me a coffee

[![](https://img.buymeacoffee.com/api/?url=aHR0cHM6Ly9pbWcuYnV5bWVhY29mZmVlLmNvbS9hcGkvP25hbWU9YWRuYW50dXJraSZzaXplPTMwMCZiZy1pbWFnZT1ibWMmYmFja2dyb3VuZD1mZjgxM2Y=&creator=adnanturki&is_creating=building%20cool%20things%20every%20single%20f**king%20day.&design_code=1&design_color=%23ff813f&slug=adnanturki)](https://www.buymeacoffee.com/adnanturki)

### How to contribute

- Create a fork, make changes and send a pull request.
- Raise a issue

### License

Licensed under Apache 2.0. You can check its details [here](https://choosealicense.com/licenses/apache-2.0/ "here").
