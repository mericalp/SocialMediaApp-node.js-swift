const express = require('express')
const User = require('../models/user')
const multer = require('multer')
const sharp = require('sharp')
const auth = require('../middleware/auth')
const { updateOne } = require('../models/post')
const router = new express.Router()

// utility
const upload = multer({
    limits:{
        fileSize: 100000000
    }
})

/**
 * @swagger
 * /user:
 *   post:
 *     summary: Kullanıcı oluştur.
 *     description: Kullanıcı oluşturmanızı sağlar.
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
 *             name:
 *               type: string,
 *               required: true
 *             username:
 *               type: string,
 *             email:
 *               type: string,
 *               required: true
 *             password:
 *               type: string,
 *               required: true
 *             token:
 *               type: string,
 *               required: true
 *             avatar:
 *               type: string,
 *             avatarExists:
 *               type: Boolean,
 *             bio: 
 *               type: string,
 *             website:
 *               type: string,
 *             location:
 *               type: string,
 *             followers:
 *               type: array,
 *             followings:
 *               type: array
 *     responses:
 *       200:
 *         description: Kullanıcı oluşturma başarılı.
 *         schema:
 *           type: object
 *           properties:
 *             name:
 *               type: string,
 *               required: true
 *             username:
 *               type: string,
 *             email:
 *               type: string,
 *               required: true
 *             password:
 *               type: string,
 *               required: true
 *             token:
 *               type: string,
 *               required: true
 *             avatar:
 *               type: string,
 *             avatarExists:
 *               type: Boolean,
 *             bio: 
 *               type: string,
 *             website:
 *               type: string,
 *             location:
 *               type: string,
 *             followers:
 *               type: array,
 *             followings:
 *               type: array
 *       400:
 *         description: "Bir Hata Belirdi !"
 */

router.post('/users', async (req, res) => {
    const user = new User(req.body)

    try {
        await user.save()
        res.status(201).send(user)
    } catch (e) {
        res.status(400).send(e)
    }
})

/**
 * @swagger
 * /users:
 *  get:
 *      summary: Kullanıcıları getirir.
 *      description: Kullanıcıları listeler.
 *      responses:
 *          201:
 *              description: Kullanıcılar Başarıyla Listelendi.
 *          400: 
 *              description: Bildirim gösterilemiyor,daha sonra tekrar dene!
 *          401:
 *              description: Please authenticate. / Lütfen kimliğinizi doğrulayın.
 */

router.get('/users', async (req, res) => {
    try {
        const users = await User.find({})
        res.send(users)
    } catch (e) {
        res.status(500).send(e)

    }
})

// Login User
router.post('/users/login',async (req, res) => { 
    try {
        const user = await User.findByCredentials(req.body.email, req.body.password)
        const token = await user.generateAuthToken()
        res.send({user, token})
    } catch(e) {
        res.status(500).send(e)
    }
})

// Delete User
router.delete('/users/:id', async (req, res) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id)
    
    if(!user){
        return res.status(400).send()
    }
    res.send()
  } catch(e) {
        res.status(500).send(e)
   } 
})

// Fetch user for search bar 
router.get('/users/:id', async (req, res) => { 
    try {
        const _id = req.params.id
        const user = await User.findById(_id)

        if(!user){
            return res.status(404).send()
        }
        res.send(user)
    } catch(e) {
        res.status(500).send(e)
    }
})

// Upload Profile Image
router.post('/users/me/avatar', auth, upload.single('avatar'), async (req, res) => { 
    const buffer = await sharp(req.file.buffer).resize({width: 250, height: 250}).png().toBuffer()

    if(req.user.avatar != null){
        req.user.avatar = null
        req.user.avatarExists = false
    }
    req.user.avatar = buffer
    req.user.avatarExists = true
    await req.user.save()

    res.send(buffer)
},(error, req, res, next) => {
    res.status(400).send({error: error.message})
})

// Fetch user profile image
router.get('/users/:id/avatar', async (req, res) => {
    try {
        const user = await User.findById(req.params.id)
        if(!user || !user.avatar) {
            throw new Error("user not found")
        }

        res.set('Content-Type', 'image/jpg')
        res.send(user.avatar)
    } catch(e) {
        res.status(404).send()
    }
})

// Following  
router.put('/users/:id/follow', auth, async (req,res) => { 
    if(req.user.id != req.params.id) { 
        try { 
            const user = await User.findById(req.params.id)
            if(!user.followers.includes(req.user.id)) { 
                await user.updateOne({ $push: { followers: req.user.id}})
                await req.user.updateOne({ $push: { followings: req.params.id}})
                res.status(200).json('u has been followed')
            } else {
                res.status(403).json('already follow')
            }
        } catch(e) { 
            res.status(500).json(e)
        }
    } else {
        res.status(403).json('you cnnt follow yourself wtf')
    }
})


// Unfollow
router.put('/users/:id/unfollow', auth, async (req, res) => {
    if(req.user.id != req.params.id) { 
        try { 
            const user = await User.findById(req.params.id)
            if(user.followers.includes(req.user.id)) { 
                await user.updateOne({ $pull: { followers: req.user.id }})
                await req.user.updateOne({ $pull: { followings: req.params.id }})
                res.status(200).json('u has been unfollowed')
            } else {
                res.status(403).json('u dont do this')
            }
        } catch(e) { 
            res.status(500).json(e)
        }
    } else { 
        res.status(403).json('u cannot unfollow yourself wtf')
    }
})

// User update 
router.patch('/users/:id', auth, upload.single('avatar'), async (req, res) => {
    const updates = Object.keys(req.body)
    console.log(updates)
    const allowedUpdates = ['name', 'email', 'password', 'age', 'website', 'bio', 'location']
    const isValidOperation = updates.every((update) => allowedUpdates.includes(update))
    
    if (!isValidOperation) {
        return res.status(400).send({
            error: 'Invalid updates!'
        })
    }

    try {
        const user = await User.findById(req.params.id)
        // console.log(user)
        // console.log(req.body)
        // console.log(user['name'])
        // console.log(req.body['name'])
        updates.forEach((update) => user[update] = req.body[update])
        await user.save()

        if (!user) {
            return res.status(404).send()
        }

        res.send(user)
    } catch (e) {
        res.status(400).send(e)
    }
})


module.exports = router
