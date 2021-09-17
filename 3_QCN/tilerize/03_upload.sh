## init env
pip install earthengine-api --upgrade
pip install retrying
pip install requests_toolbelt
pip install chromedriver_binary
pip install selenium
pip install webdriver-manager
pip install pipwin

git clone https://github.com/samapriya/geeup.git
cd geeup

## authenticate
python
import ee
ee.Authenticate()
exit()

## upload
cd /d E:\OneDrive_IPAM\OneDrive - IPAM\IPAM\7_SEEG\1_QCN\r_code\gee_asset_manager
python geebam.py upload -u dh.conciani@gmail.com --source ..\output --dest projects/mapbiomas-workspace/SEEG/2021/QCN/QCN_30m --metadata ..\metadata.csv
