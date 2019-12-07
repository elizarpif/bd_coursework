import yaml
from dataclasses import dataclass, field
from datetime import datetime
from dataclasses_json import DataClassJsonMixin
from marshmallow import fields
from yamldataclassconfig.config import YamlDataClassConfig


@dataclass
class DbConfig(YamlDataClassConfig):
    dbhost: str = None
    dbname: str = None
    dbrole: str = None
    dbpassword: str = None
@dataclass
class Ui(YamlDataClassConfig):
    search: str = None
    main: str = None
    connect: str = None
    infoAbout: str = None
@dataclass
class Images(YamlDataClassConfig):
    icon: str = None

@dataclass
class Config(YamlDataClassConfig):
    db: DbConfig = None
    ui: Ui = None
    images: Images = None
    # def __init__(self):
    #     with open('configs/config.yaml') as f:
    #         cfg = yaml.load(f, Loader=yaml.FullLoader)
    #     print(cfg['db']['dbname'])
    #     print(cfg['ui'])
    #     print(cfg['images'])