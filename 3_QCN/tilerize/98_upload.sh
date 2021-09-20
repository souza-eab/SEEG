## set init environment using anaconda
pip install geeup
geeup init
earthengine authenticate

## upload
cd C:\Users\dhemerson.costa\OneDrive - INSTITUTO DE PESQUISA AMBIENTAL DA AMAZÔNIA\IPAM\7_SEEG\1_QCN\r_code
geeup upload -u dh.conciani@gmail.com --source C:\Users\dhemerson.costa\Desktop\to_up --dest projects/mapbiomas-workspace/SEEG/2021/QCN/QCN_30m --metadata C:\Users\dhemerson.costa\Desktop\metadata.csv
