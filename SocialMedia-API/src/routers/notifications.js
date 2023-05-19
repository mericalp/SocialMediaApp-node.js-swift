const express = require('express')
const auth = require('../middleware/auth')
const Notification = require('../models/notifications')
const router = new express.Router()


/**
 * @swagger
 * /notification:
 *   post:
 *     summary: Bildirim oluşturur.
 *     description: Bildirim oluşturmamızı sağlar.
 *     consumes:
 *       - application/json
 *     produces:
 *       - application/json
 *     parameters:
 *       - in: body
 *         name: body
 *         description: İstek gövdesi.
 *         required: true
 *         schema:
 *           type: object
 *           properties:
 *             username:
 *               type: string,
 *             notSenderId:
 *               type: integer,
 *               required: true
 *             notReceiverId:
 *               type: integer,
 *             notificationType:
 *               type: string,
 *             postText:
 *               type: string
 *     responses:
 *       200:
 *         description: Bildirim başarıyla oluşturuldu.
 *         schema:
 *           type: object
 *           properties:
 *             message:
 *               type: string
 *               description: Bildirim başarıyla oluşturuldu.
 *             data:
 *               type: object
 *               description: Bildirim başarıyla oluşturuldu.
 *               properties:
 *                 username:
 *                    type: string,
 *                 notSenderId:
 *                    type: integer,
 *                    required: true
 *                 notReceiverId:
 *                    type: integer
 *                 notificationType:
 *                    type: string,
 *                 postText:
 *                    type: string
 *       400:
 *         description: "Bir Hata Belirdi !"
 */

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

notification.get('/notification/:id', auth, async (req, res) => { 
    const _id = req.params.id

    try{ 
        const notification = await Notification.find({ notReceiverId: _id})
        res.status(200).send(notification)
    } catch(e) { 
        res.status(400).send(e)
    }

})

module.exports = router
