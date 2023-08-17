var express = require('express'),
routes = express.Router()
var userController=require("../controller/user-controller")
routes.post('/register',userController.addUser)
routes.post('/login',userController.login)
routes.post('/getuser',userController.findUser)

routes.post('/updatePhoneNumber',userController.updatePhoneNumber)
routes.post('/updateEmail',userController.updateEmail)
routes.post('/updatePassword',userController.updatePassword)
routes.post('/findUserByEmail',userController.findUserByEmail)

module.exports = routes