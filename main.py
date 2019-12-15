from PyQt5.QtCore import QObject
from PyQt5.QtGui import QIcon
from PyQt5.QtWidgets import *
from config.config import Config
from PyQt5 import uic, QtWidgets, QtSql

CONFIG: Config = Config()


class ChangeInfoRetiree(QDialog):
    def __init__(self, conf, s, n, p, addr, sn):
        super(ChangeInfoRetiree, self).__init__()
        self.ui = uic.loadUi(conf.ui.updateRetireeInfo, self)
        self.ln_surname.setText(s)
        self.ln_name.setText(n)
        self.ln_patronymic.setText(p)
        self.ln_address.setText(addr)
        self.ln_snils.setText(sn)
        self.accepted_btn.clicked.connect(self.Accepted)
        self.canceled_btn.clicked.connect(self.Cancel)

    def getRetireeParams(self):
        return self.ln_surname.text(), \
               self.ln_name.text(), self.ln_patronymic.text(), \
               self.ln_snils.text(), self.ln_address.text()

    def Accepted(self):
        self.accept()

    def Cancel(self):
        self.close()


class AddMonthPayment(QDialog):
    def __init__(self, conf):
        super(AddMonthPayment, self).__init__()
        self.ui = uic.loadUi(conf.ui.addMonthPayment, self)
        self.accepted_btn.clicked.connect(self.Accepted)
        self.canceled_btn.clicked.connect(self.Cancel)

    def getRetireeParams(self):
        return self.month_box.value(), self.year_box.value()

    def Accepted(self):
        self.accept()

    def Cancel(self):
        self.close()


class AddWorkRetiree(QDialog):
    def __init__(self, conf, deleted):
        super(AddWorkRetiree, self).__init__()
        self.ui = uic.loadUi(conf.ui.addWork, self)
        self.accepted_btn.clicked.connect(self.Accepted)
        self.canceled_btn.clicked.connect(self.Cancel)
        if deleted:
            self.setWindowTitle('Укажите удаляемые данные')

    def getRetireeParams(self):
        return self.ln_place.text(), self.ln_experience.text(), self.ln_payment.text()

    def Accepted(self):
        self.accept()

    def Cancel(self):
        self.close()


class AddPension(QDialog):
    def __init__(self, conf, deleted):
        super(AddPension, self).__init__()
        self.ui = uic.loadUi(conf.ui.addPension, self)
        self.accepted_btn.clicked.connect(self.Accepted)
        self.canceled_btn.clicked.connect(self.Cancel)
        if deleted:
            self.setWindowTitle('укажите удаляемые данные')

    def getRetireeParams(self):
        return self.combo.currentText()

    def Accepted(self):
        self.accept()

    def Cancel(self):
        self.close()


class Search(QDialog):
    def __init__(self, conf):
        super(Search, self).__init__()
        self.ui = uic.loadUi(conf.ui.search, self)
        self.search_btn.clicked.connect(self.Accepted)

    def getRetireeParams(self):
        return self.ln_snils.text()

    def Accepted(self):
        self.accept()


class NotModerator(QDialog):
    def __init__(self, conf):
        super(NotModerator, self).__init__()
        self.ui = uic.loadUi(conf.ui.notModerator, self)
        self.accepted_btn.clicked.connect(self.Accepted)

    def Accepted(self):
        self.accept()

class Login(QDialog):
    def __init__(self, conf: CONFIG):
        super(Login, self).__init__()
        self.ui = uic.loadUi(conf.ui.login, self)
        self.accepted_btn.clicked.connect(self.Accepted)
        self.canceled_btn.clicked.connect(self.Cancel)

    def getParams(self):
        return self.login, self.password

    def Accepted(self):
        self.login = self.ln_login.text()
        self.password = self.ln_password.text()
        self.accept()

    def Cancel(self):
        self.login = ""
        self.password = ""
        self.close()


class Client(QMainWindow):
    def LoadConfigParams(self):
        self.icon = self.Config.images.icon

        self.dbhost = self.Config.db.dbhost
        self.dbrole = self.Config.db.dbrole
        self.dbname = self.Config.db.dbname
        self.dbpass = self.Config.db.dbpassword

        self.dbworker = self.Config.db.worker
        self.dbworker_password = self.Config.db.worker_password

        self.ui = self.Config.ui

    def __init__(self, conf):
        super(Client, self).__init__()
        self.Config = conf
        self.LoadConfigParams()

        self.setWindowIcon(QIcon(self.Config.images.icon))
        self.ui = uic.loadUi(self.Config.ui.main, self)

        self.login_btn.clicked.connect(self.Login)
        self.unlogin_btn.setEnabled(False)
        self.unlogin_btn.clicked.connect(self.UnLogin)
        self.Connect()
        self.search_btn.clicked.connect(self.Search)
        self.IsWorker = False
        self.Info = InfoRetiree(self.Config)
        self.ModerInfoRetiree = ModerInfoRetiree(self.Config)
        # self.combo.currentTextChanged.connect(self.comboChange)

    def UnLogin(self):
        self.unlogin_btn.setEnabled(False)
        self.IsWorker = False
        print("open db with default params")
        self.db.setUserName(self.dbrole)
        self.db.setPassword(self.dbpass)
        if not (self.db.open()):
            print(self.db.lastError())
        if (self.ModerInfoRetiree.isVisible()):
            self.ModerInfoRetiree.close()
    def Login(self):
        login = Login(self.Config)
        login.show()
        if (login.exec() == QDialog.Accepted):
            self.role, self.password = login.getParams()
            curUser = self.db.userName()
            curPass = self.db.password()
            self.db.setUserName(self.dbworker)
            self.db.setPassword(self.dbworker_password)
            if (self.db.open()):
                self.IsWorker = True
                print("db open with worker options")
                query = "select * from moderator('{}','{}');".format(self.role, self.password)
                sql = QtSql.QSqlQuery()
                res = sql.exec(query)
                while sql.next():
                    tf = sql.value("moderator")
                    if tf:
                        self.unlogin_btn.setEnabled(True)
                        if (self.Info.isVisible()):
                            self.Info.close()
                        return
                # диалог
                print(tf)
                mod = NotModerator(self.Config)
                mod.show()
            self.unlogin_btn.setEnabled(False)
            print(self.db.lastError())
            self.IsWorker = False
            print("open db with default params")
            self.db.setUserName(curUser)
            self.db.setPassword(curPass)
            if not (self.db.open()):
                print(self.db.lastError())

        # if (login.exec() == QDialog.Rejected):

    # добавить информацию о выллатах, типах пенсий
    def Search(self):
        src = Search(self.Config)
        src.show()
        if (src.exec() == QDialog.Rejected):
            return
        snils = src.getRetireeParams()
        if not self.db.open():
            print(self.db.databaseName())
            print("db not opened")
            return
        if self.IsWorker:
            self.ModerInfoRetiree.show()
            self.ModerInfoRetiree.setDb(self.db)
            self.ModerInfoRetiree.setInfo(snils)
            self.ModerInfoRetiree.InitInfo()
        else:
            self.Info.show()
            self.Info.setDb(self.db)
            self.Info.setInfo(snils)
            self.Info.InitInfo()
        # self.setVisible(False)

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


class ModerInfoRetiree(QMainWindow):
    def __init__(self, config):
        super(ModerInfoRetiree, self).__init__()
        self.setInfo("")
        self.patronymic = ""
        self.ui = uic.loadUi(config.ui.moderatorInfo, self)
        self.Config = config
        self.combo.currentTextChanged.connect(self.comboChange)
        self.add_btn.clicked.connect(self.changeInfo)
        self.update_btn.clicked.connect(self.updateTable)
        self.delete_btn.clicked.connect(self.deleteChoose)
        self.delete_btn.setVisible(False)
        self.combo.setCurrentIndex(0)


    def changeInfo(self):
        if (self.combo.currentText() == 'Личная информация'):
            self.changeRetireeInfo()
        if (self.combo.currentText() == 'Опыт работы'):
            self.addRetireeWork()
        if (self.combo.currentText() == 'Пенсии'):
            self.addRetireePension()
        if (self.combo.currentText() == 'Итоговые суммы'):
            self.addMonthPayment()

    def addMonthPayment(self):

        ### получить последний месяц и год
        query = "select * from get_year('{}')".format(self.snils)
        sql = QtSql.QSqlQuery()
        res = sql.exec(query)
        while sql.next():
            self.year = sql.value("get_year")
            if (self.year == 0):
                self.year = 2019
            print(self.year)
        query = "select * from get_month('{}', {})".format(self.snils, self.year)
        sql = QtSql.QSqlQuery()
        sql.exec(query)
        while sql.next():
            self.month = sql.value("get_month")
            print(self.month)
        if (self.month == 12):
            self.month = 0
            self.year = self.year + 1
        query = "call addMonthPayment('{}',{},{});".format(self.snils, self.month + 1, self.year)
        print(query)
        sql = QtSql.QSqlQuery()
        res = sql.exec(query)
        print(res)
        self.updateTable()
        print(sql.lastError().text())

    def deleteMonthPayment(self):
        ### получить последний месяц и год
        query = "select * from get_year('{}')".format(self.snils)
        sql = QtSql.QSqlQuery()
        res = sql.exec(query)
        while sql.next():
            self.year = sql.value("get_year")

        query = "select * from get_month('{}', {})".format(self.snils, self.year)
        sql = QtSql.QSqlQuery()
        sql.exec(query)
        while sql.next():
            self.month = sql.value("get_month")
        query = "call delete_month('{}', {}, {})".format(self.snils, self.month, self.year)
        print(query)
        sql = QtSql.QSqlQuery()
        res = sql.exec(query)
        print(res)
        print(sql.lastError().text())
        self.updateTable()


    def changeRetireeInfo(self):
        newInfo = ChangeInfoRetiree(self.Config, self.surname, self.name, self.patronymic, self.address, self.snils)
        newInfo.show()
        if (newInfo.exec() == QDialog.Accepted):
            surname, name, patronymic, snils, address = newInfo.getRetireeParams()
            print('pfrs ', newInfo.getRetireeParams())
            query = "call changeRetireeInfo('{}','{}','{}', '{}','{}', '{}');".format(surname, name, patronymic, snils,
                                                                                      address, self.snils)
            sql = QtSql.QSqlQuery(query)
            sql.exec()
            self.snils = snils
            self.name = name
            self.patronymic = patronymic
            self.surname = surname
            self.fio_info_lb.setText(self.surname + " " + self.name + " " + self.patronymic)

            self.updateTable()

    def InfoPension(self):
        query = "select * from InfoPension('{}');".format(self.snils)
        sqlQuery = QtSql.QSqlQuery(query)
        sql = QtSql.QSqlRelationalTableModel()
        sql.setQuery(sqlQuery)
        sql.setHeaderData(0, 0x1, 'Тип пенсии')
        sql.setHeaderData(1, 0x1, 'Пенсия')
        sql.setHeaderData(2, 0x1, 'Выплата')

        self.table.setModel(sql)

    def addRetireeWork(self):
        newWork = AddWorkRetiree(self.Config, False)
        newWork.show()
        if (newWork.exec() == QDialog.Accepted):
            place, exp, payment = newWork.getRetireeParams()
            query = "call addWork({},'{}','{}', {},'{}');".format(exp, payment, place, 6.6, self.snils)
            print(query)
            sql = QtSql.QSqlQuery()
            res = sql.exec(query)
            self.updateTable()

    def deleteChoose(self):
        #if (self.combo.currentText() == 'Личная информация'):
           # self.changeRetireeInfo()
        if (self.combo.currentText() == 'Опыт работы'):
            self.deleteRetireeWork()
        if (self.combo.currentText() == 'Пенсии'):
            self.deleteRetireePension()
        if (self.combo.currentText() == 'Итоговые суммы'):
            self.deleteMonthPayment()

    def deleteRetireeWork(self):
        newWork = AddWorkRetiree(self.Config, True)
        newWork.show()
        if (newWork.exec() == QDialog.Accepted):
            place, exp, payment = newWork.getRetireeParams()
            query = "call delete_work('{}','{}',{}, {});".format(self.snils, place, exp, payment)
            print(query)
            sql = QtSql.QSqlQuery()
            res = sql.exec(query)
            self.updateTable()
            print(sql.lastError().text())

    def addRetireePension(self):
        newPension = AddPension(self.Config, False)
        newPension.show()
        if (newPension.exec() == QDialog.Accepted):
            pension_type = newPension.getRetireeParams()
            query = "select * from isExistPension('{}','{}')".format(pension_type, self.snils)
            print(query)
            sql = QtSql.QSqlQuery()
            res = sql.exec(query)
            while sql.next():
                tf = sql.value("isexistpension")
                if not tf:
                    query = "call addPension('{}','{}');".format(pension_type, self.snils)
                    print(query)
                    sql = QtSql.QSqlQuery(query)
                    print(sql.lastError().text())
                    self.updateTable()

    def deleteRetireePension(self):
        newPension = AddPension(self.Config, True)
        newPension.show()
        if (newPension.exec() == QDialog.Accepted):
            pension_type = newPension.getRetireeParams()
            query = "select * from isExistPension('{}','{}')".format(pension_type, self.snils)
            print(query)
            sql = QtSql.QSqlQuery()
            res = sql.exec(query)
            while sql.next():
                tf = sql.value("isexistpension")
                if not tf:
                    query = "call delete_pension('{}','{}');".format(self.snils, pension_type)
                    print(query)
                    sql = QtSql.QSqlQuery(query)
                    print(sql.lastError().text())
                    self.updateTable()

    def comboChange(self, value):
        if (value == "Личная информация"):
            self.add_btn.setText("Изменить")
            self.delete_btn.setVisible(False)
            self.InfoAboutRetiree()
        if (value == "Опыт работы"):
            self.add_btn.setText("Добавить")
            self.delete_btn.setVisible(True)
            self.InfoWorkExperience()
        if (value == "Итоговые суммы"):
            self.add_btn.setText("Добавить")
            self.delete_btn.setVisible(True)
            self.InfoResultSummas()
        if (value == "Пенсии"):
            self.add_btn.setText("Добавить")
            self.delete_btn.setVisible(True)
            self.InfoPension()

    def updateTable(self):
        self.comboChange(self.combo.currentText())

    def InitInfo(self):
        query = "select * from info_retiree('{}');".format(self.snils)
        sql = QtSql.QSqlQuery(query)
        while sql.next():
            self.name = sql.value("name")
            self.surname = sql.value("surname")
            self.patronymic = sql.value("patronymic")
            self.address = sql.value("address")
        self.fio_info_lb.setText(self.surname + " " + self.name + " " + self.patronymic)
        self.combo.setCurrentIndex(0)
        self.InfoAboutRetiree()

    def InfoAboutRetiree(self):
        sql = QtSql.QSqlRelationalTableModel()
        sqlQuery = QtSql.QSqlQuery(
            "select * from info_retiree('{}');".format(self.snils))
        sql.setQuery(sqlQuery)
        sql.setHeaderData(0, 0x1, 'Фамилия')
        sql.setHeaderData(1, 0x1, 'Имя')
        sql.setHeaderData(2, 0x1, 'Отчество')
        sql.setHeaderData(3, 0x1, 'Дата регистрации')
        sql.setHeaderData(4, 0x1, 'СНИЛС')
        sql.setHeaderData(5, 0x1, 'Адрес')
        self.table.setModel(sql)

    def setDb(self, db):
        self.db = db

    def setInfo(self, snils):
        self.snils = snils
        self.surname=''
        self.name=''
        self.patronymic=''
        self.address=''

    def InfoResultSummas(self):
        sql = QtSql.QSqlRelationalTableModel()
        query = "select * from info_summas('{}');".format(self.snils)
        sqlQuery = QtSql.QSqlQuery(query)
        sql.setQuery(sqlQuery)
        sql.setHeaderData(0, 0x1, 'Месяц')
        sql.setHeaderData(1, 0x1, 'Месячные выплаты')
        sql.setHeaderData(2, 0x1, 'Итог с начала года')
        sql.setHeaderData(3, 0x1, 'Год')
        self.table.setModel(sql)

    def InfoWorkExperience(self):
        sqlQuery = QtSql.QSqlQuery("select * from info_work_experience('{}');".format(self.snils))
        sql = QtSql.QSqlRelationalTableModel()
        sql.setQuery(sqlQuery)
        sql.setHeaderData(0, 0x1, 'Опыт работы')
        sql.setHeaderData(1, 0x1, 'Страховой взнос')
        sql.setHeaderData(2, 0x1, 'Место работы')

        self.table.setModel(sql)


class InfoRetiree(QMainWindow):
    def __init__(self, config):
        super(InfoRetiree, self).__init__()
        self.setInfo("")
        self.patronymic = ""
        self.ui = uic.loadUi(config.ui.infoAbout, self)
        self.work_experience_btn.clicked.connect(self.InfoWorkExperience)
        self.cv_btn.clicked.connect(self.InfoAboutRetiree)
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
        query = "select * from info_retiree('{}');".format(self.snils)
        sql = QtSql.QSqlQuery(query)
        while sql.next():
            self.name = sql.value("name")
            self.surname = sql.value("surname")
            self.patronymic = sql.value("patronymic")
        self.fio_info_lb.setText(self.surname + " " + self.name + " " + self.patronymic)
        self.InfoAboutRetiree()

    def InfoAboutRetiree(self):
        sql = QtSql.QSqlQueryModel()
        query = "select * from info_retiree('{}');".format(self.snils)
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

    def setInfo(self, snils):
        self.snils = snils

    def InfoResultSummas(self):
        sql = QtSql.QSqlQueryModel()
        query = "select * from info_summas('{}');".format(self.snils)
        sql.setQuery(query)
        sql.setHeaderData(0, 0x1, 'Месяц')
        sql.setHeaderData(1, 0x1, 'Месячные выплаты')
        sql.setHeaderData(2, 0x1, 'Итог с начала года')
        sql.setHeaderData(3, 0x1, 'Год')
        self.table.setModel(sql)


if __name__ == "__main__":
    import sys

    app = QtWidgets.QApplication(sys.argv)
    config = Config()
    config.load("configs/config.yaml")
    window = Client(config)
    window.show()

    app.exec_()
