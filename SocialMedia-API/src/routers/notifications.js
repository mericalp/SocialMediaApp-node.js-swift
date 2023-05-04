const express = require('express')
const auth = require('../middleware/auth')
const Notification = require('../models/notifications')
const router = new express.Router()

router.post('/notification', auth, async (req, res) => {
    const notification = new Notification({
        ...req.body,
        user: req.user._id
    })

    try { 
        await notification.save()
        res.status(201).send(notification)
    } catch(e) { 
        res.status(400).send(e)
    }
})

router.get('/notification/:id', auth, async (req, res) => { 
    const _id = req.params.id

    try{ 
        const notification = await Notification.find({ notReceiverId: _id})
        res.status(200).send(notification)
    } catch(e) { 
        res.status(400).send(e)
    }

})

module.exports = router
