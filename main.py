from PyQt5.QtCore import QObject
from PyQt5.QtGui import QIcon
from PyQt5.QtWidgets import *
from config.config import Config
from PyQt5 import uic, QtWidgets, QtSql
CONFIG: Config = Config()


class Search(QDialog):
    def __init__(self, conf):
        super(Search, self).__init__()
        self.ui = uic.loadUi(conf.ui.search, self)
        self.setWindowTitle("Search retiree")
        self.search_btn.clicked.connect(self.Accepted)

    def getRetireeParams(self):
        return self.ln_name.text(), self.ln_surname.text(), self.ln_snils.text()

    def Accepted(self):
        self.accept()


# class Connect(QDialog):
#     def __init__(self):
#         super(Connect,self).__init__()
#         self.ui = uic.loadUi("connect.ui", self)
#         self.setWindowTitle("Connect to database")
#         self.accepted_btn.clicked.connect(self.Accepted)
#         self.canceled_btn.clicked.connect(self.Cancel)
#
#     def getDbParams(self):
#         return self.ln_db.text(), self.ln_host.text(), self.ln_role.text(), self.ln_password.text()
#
#     def Accepted(self):
#         self.accept()
#     def Cancel(self):
#         self.close()

class Client(QMainWindow):
    def LoadConfigParams(self):
        self.icon = self.Config.images.icon

        self.dbhost = self.Config.db.dbhost
        self.dbrole = self.Config.db.dbrole
        self.dbname = self.Config.db.dbname
        self.dbpass = self.Config.db.dbpassword

        self.ui = self.Config.ui

    def __init__(self, conf):
        super(Client, self).__init__()
        self.Config = conf
        self.LoadConfigParams()

        self.setWindowTitle('Title')

        self.setWindowIcon(QIcon(self.Config.images.icon))
        self.ui = uic.loadUi(self.Config.ui.main, self)

        # self.connect_btn.clicked.connect(self.Connect)
        self.search_btn.clicked.connect(self.Search)

        self.Info = InfoRetiree(self.Config)
        # self.combo.currentTextChanged.connect(self.comboChange)

# добавить информацию о выллатах, типах пенсий
    def Search(self):
        print("in search")
        src = Search(self.Config)
        src.show()
        if (src.exec() == QDialog.Rejected):
            return
        name, surname, snils = src.getRetireeParams()
        self.Connect()
        if not self.db.open():
            print(self.db.databaseName())
            print("db not opened")
            return
        self.Info.show()
        self.Info.setDb(self.db)
        self.Info.setInfo(name, surname, snils)
        self.Info.InitInfo()
        self.setVisible(False)

        # self.colcount = rec.count()

    def Connect(self):

        db, host, role, passw = self.dbname, self.dbhost, self.dbrole, self.dbpass
        self.db = QtSql.QSqlDatabase.addDatabase("QPSQL")

        if not self.db.isValid():
            print("ERROR (in base)")
            return

        self.db.setHostName(host)
        self.db.setDatabaseName(db)
        self.db.setUserName(role)
        self.db.setPassword(passw)


class InfoRetiree(QMainWindow):
    def __init__(self, config):
        super(InfoRetiree, self).__init__()
        self.setInfo("", "", "")
        self.patronymic = ""
        self.ui = uic.loadUi(config.ui.infoAbout, self)
        self.work_experience_btn.clicked.connect(self.InfoWorkExperience)
        self.cv_btn.clicked.connect(self.InfoRetiree)
        self.pension_btn.clicked.connect(self.InfoResultSummas)
        # self.connect_btn.clicked.connect(self.Connect)

    def InfoWorkExperience(self):
        sql = QtSql.QSqlQueryModel()
        query = "select * from info_work_experience('{}');".format(self.snils)
        sql.setQuery(query)
        sql.setHeaderData(0, 0x1, 'Опыт работы')
        sql.setHeaderData(1, 0x1, 'Страховой взнос')
        sql.setHeaderData(2, 0x1, 'Место работы')

        self.table.setModel(sql)

    def InitInfo(self):
        query = "select * from info_retiree('{}','{}','{}');".format(self.name, self.surname, self.snils)
        sql = QtSql.QSqlQuery(query)
        while sql.next():
            self.name = sql.value("name")
            self.surname = sql.value("surname")
            self.patronymic = sql.value("patronymic")
        self.fio_info_lb.setText(self.surname+" "+self.name+" "+self.patronymic)
        self.InfoRetiree()

    def InfoRetiree(self):
        sql = QtSql.QSqlQueryModel()
        query = "select * from info_retiree('{}','{}','{}');".format(self.name, self.surname, self.snils)
        sql.setQuery(query)
        sql.setHeaderData(0, 0x1, 'Фамилия')
        sql.setHeaderData(1, 0x1, 'Имя')
        sql.setHeaderData(2, 0x1, 'Отчество')
        sql.setHeaderData(3, 0x1, 'Дата регистрации')
        sql.setHeaderData(4, 0x1, 'СНИЛС')
        sql.setHeaderData(5, 0x1, 'Адрес')
        self.table.setModel(sql)

    def setDb(self, db):
        self.db = db

    def setInfo(self, name, surname, snils):
        self.name = name
        self.surname = surname
        self.snils = snils

    def InfoResultSummas(self):
        sql = QtSql.QSqlQueryModel()
        query = "select * from info_summas('{}');".format(self.snils)
        sql.setQuery(query)
        sql.setHeaderData(0, 0x1, 'Январь')
        sql.setHeaderData(1, 0x1, 'Февраль')
        sql.setHeaderData(2, 0x1, 'Март')
        sql.setHeaderData(3, 0x1, 'Апрель')
        sql.setHeaderData(4, 0x1, 'Май')
        sql.setHeaderData(5, 0x1, 'Июнь')
        sql.setHeaderData(6, 0x1, 'Июль')
        sql.setHeaderData(7, 0x1, 'Август')
        sql.setHeaderData(8, 0x1, 'Сентябрь')
        sql.setHeaderData(9, 0x1, 'Октябрь')
        sql.setHeaderData(10, 0x1, 'Ноябрь')
        sql.setHeaderData(11, 0x1, 'Декабрь')
        sql.setHeaderData(12, 0x1, 'Год')
        sql.setHeaderData(13, 0x1, 'Итог')
        self.table.setModel(sql)


if __name__ == "__main__":
    import sys

    app = QtWidgets.QApplication(sys.argv)
    config = Config()
    config.load("configs/config.yaml")
    window = Client(config)
    window.show()

    app.exec_()
