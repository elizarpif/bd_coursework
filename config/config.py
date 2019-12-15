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
    worker: str = None
    worker_password: str = None
@dataclass
class Ui(YamlDataClassConfig):
    search: str = None
    main: str = None
    login: str = None
    infoAbout: str = None
    notModerator: str = None
    moderatorInfo: str = None
    addPension: str = None
    addWork: str = None
    updateRetireeInfo: str = None
    addMonthPayment: str = None
@dataclass
class Images(YamlDataClassConfig):
    icon: str = None

@dataclass
class Config(YamlDataClassConfig):
    db: DbConfig = None
    ui: Ui = None
    images: Images = None