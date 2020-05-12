# DevOpsAssessment-Isazi
Isazi Consulting DevOps Assessment

### Prerequisite:

* Make the file install.sh executable by running the folowing command:

``` bash
sudo chmod +x install.sh
```

* The script **install.sh** assumes you are running the docker command as a user in the docker user group.
* If your not logged in as **root** user add your current user to the docker group:
```bash
sudo usermod -aG docker $(whoami)
```
You will need to log out and back in as the same user to enable this change.


* Running as other user:
```bash
sudo ./install.sh
```

* Running as root:
```bash
./install
```
