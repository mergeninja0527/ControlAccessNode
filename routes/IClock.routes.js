const { Router } = require('express')
const { cdata, registry, push, getrequest, devicecmd, rtdata, querydata } = require('../controllers/IClock.controller.js')
// const { Db2 } = require('../utils/DatabaseUtils.js')

const router = Router()

//cdata
router.post('/iclock/cdata', cdata)
router.get('/iclock/cdata', cdata)

//registry
router.post('/iclock/registry', registry)
router.get('/iclock/registry', registry)

//push
router.post('/iclock/push', push)
router.get('/iclock/push', push)

//getrequest
router.post('/iclock/getrequest', getrequest)
router.get('/iclock/getrequest', getrequest)


//rtdata
router.post('/iclock/rtdata', rtdata)
router.get('/iclock/rtdata', rtdata)

//querydata
router.post('/iclock/querydata', querydata)
router.get('/iclock/querydata', querydata)

//devicecmd
router.post('/iclock/devicecmd', devicecmd)
router.get('/iclock/devicecmd', devicecmd)

module.exports = {
  iclockRouter: router
}