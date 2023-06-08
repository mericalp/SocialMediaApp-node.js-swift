const express = require('express')
const post =   require('../models/post')
const auth = require('../middleware/auth')
const Posts = require('../models/post')
const sharp = require('sharp')
const multer = require('multer')
const router = new express.Router()

// utility
const upload = multer({
    limits: {
        fileSize: 100000000
    }
})

/**
 * @swagger
 * /posts:
 *   post:
 *     summary: Post oluştur.
 *     description: Kullanıcıların post oluşturmasını sağlar.
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
 *            text:
 *               type: string,
 *               required: true
 *              user:
 *               type: string,
 *               required: true
 *              username:
 *               type: string,
 *               required: true
 *             userId:
 *               type: string,
 *               required: true
 *             image: 
 *               type: string,
 *             likes:
 *               type: array,
 *     responses:
 *       201:
 *         description: Post oluşturulduı.
 *         schema:
 *           type: object
 *           properties:
 *              text:
 *               type: string,
 *               required: true
 *              user:
 *               type: string,
 *               required: true
 *              username:
 *               type: string,
 *               required: true
 *             userId:
 *               type: string,
 *               required: true
 *             image: 
 *               type: string,
 *             likes:
 *               type: array,
 *       400:
 *         description: "Post yüklenemedi !"
 *       500:
 *         description: "Lütfen daha sonra tekrar deneyiniz"
 */

router.post('/posts', auth, async (req, res) => {
    const post = new Posts({
        ...req.body,
        user: req.user._id
    })
    try {
        await post.save()
        res.status(201).send(post)
    } catch (e) {
        res.status(400).send(e)
    }
})


/**
 * @swagger
 * /posts:
 *   post:
 *     summary: Gönderiye fotoğraf ekler.
 *     description: Kullanıcıların gönderilerine fotoğrafa eklemesini sağlar.
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
 *            text:
 *               type: string,
 *               required: true
 *              user:
 *               type: string,
 *               required: true
 *              username:
 *               type: string,
 *               required: true
 *             userId:
 *               type: string,
 *               required: true
 *             image: 
 *               type: string,
 *             likes:
 *               type: array,
 *     responses:
 *       201:
 *         description: Post oluşturulduı.
 *         schema:
 *           type: object
 *           properties:
 *              id:
 *               type: string,
 *               required: true
 *              file:
 *               type: string,
 *               required: true
 *       400:
 *         description: "Fotoğraf  yüklenemedi !"
 *       500:
 *         description: "Lütfen daha sonra tekrar deneyiniz"
 */

router.post('/uploadPostImage/:id', auth, upload.single('upload'), async (req, res) => {
    const post = await Posts.findOne({ _id: req.params.id })
    console.log(post)
    if (!post) {
        throw new Error('Cannot find the post')
    }
    const buffer = await sharp(req.file.buffer).resize({ width: 350, height: 350 }).png().toBuffer()
    console.log(buffer)
    post.image = buffer
    await post.save()
    res.send(post)
}, (error, req, res, next) => {
    res.status(400).send({ error: error.message })
})

/**
 * @swagger
 * /posts:
 *   get:
 *     summary: Gönderileri getirir.
 *     description: Kullanıcılar gönderilerini görüntüleyebilir.
 *     consumes:
 *       - application/json 
 *     produces:
 *       - application/json
 *     parameters:
 *       - in: body
 *         name: body
 *         description: İstek gövdesi.
 *         required: true
 *     responses:
 *       201:
 *         description: Gönderilier getirildi.
 *         schema:
 *           type: object
 *           properties:
 *            text:
 *               type: string,
 *               required: true
 *              user:
 *               type: string,
 *               required: true
 *              username:
 *               type: string,
 *               required: true
 *             userId:
 *               type: string,
 *               required: true
 *             image: 
 *               type: string,
 *             likes:
 *               type: array,
 *       400:
 *         description: "Gönderiler yüklenemedi !"
 *       500:
 *         description: "Lütfen daha sonra tekrar deneyiniz"
 */


router.get('/posts', async (req, res) => {
    try { 
        const posts = await Posts.find({})
        res.send(posts)
    } catch(e) {
        res.status(400).send(e)
    }
})

/**
 * @swagger
 * /posts/:id:
 *   get:
 *     summary: Spesifik Gönderiye getirir.
 *     description: Belirli Id'ye göre gönderiyi getirir.
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
 *            text:
 *               type: string,
 *               required: true
 *              user:
 *               type: string,
 *               required: true
 *              username:
 *               type: string,
 *               required: true
 *             userId:
 *               type: string,
 *               required: true
 *             image: 
 *               type: string,
 *             likes:
 *               type: array,
 *     responses:
 *       201:
 *         description: Gönderi getirildi.
 *         schema:
 *           type: object
 *           properties:
 *              id:
 *               type: string,
 *               required: true
 *              file:
 *               type: string,
 *               required: true
 *       400:
 *         description: "Gönderi getirilemedi !"
 *       500:
 *         description: "Lütfen daha sonra tekrar deneyiniz"
 */

router.get('/posts/:id', async (req, res) => {
    const _id = req.params.id

    try {
        const post = await Posts.find({ user: _id })

        if (!post) {
            return res.status(404).send()
        }

        res.send(post)
    } catch (e) {
        res.status(500).send()
    }
})

/**
 * @swagger
 * /posts/:id/image:
 *   get:
 *     summary: Spesifik Gönderiye getirir.
 *     description: Belirli Id'ye göre gönderiyi getirir.
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
 *            id:
 *               type: string,
 *               required: true
 *     responses:
 *       201:
 *         description: Gönderi getirildi.
 *         schema:
 *           type: object
 *           properties:
 *              id:
 *               type: string,
 *               required: true
 *              file:
 *               type: string,
 *               required: true
 *       400:
 *         description: "Görsel getirilemedi !"
 *       500:
 *         description: "Lütfen daha sonra tekrar deneyiniz"
 */


router.get('/posts/:id/image', async (req, res) => {
    try {
        const posts = await Posts.findById(req.params.id)

        if (!posts || !posts.image) {
            throw new Error()
        }
        res.set('Content-Type', 'image/jpg')
        res.send(posts.image)
    } catch (e) {
        res.status(404).send()
    }
})


/**
 * @swagger
 * /posts/:id/like:
 *   put:
 *     summary: Spesifik Gönderiye getirir.
 *     description: Belirli Id'ye göre gönderiyi getirir.
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
 *            id:
 *               type: string,
 *               required: true
 *     responses:
 *       201:
 *         description: Gönderi getirildi.
 *         schema:
 *           type: object
 *           properties:
 *              id:
 *               type: string,
 *               required: true
 *              file:
 *               type: string,
 *               required: true
 *       400:
 *         description: "Görsel getirilemedi !"
 *       500:
 *         description: "Lütfen daha sonra tekrar deneyiniz"
 */

router.put('/posts/:id/like', auth, async (req, res) => {
    try {
        const post = await Posts.findById(req.params.id);
        if (!post.likes.includes(req.user.id)) {
        await post.updateOne({ $push: { likes: req.user.id } });
        // await req.user.updateOne({ $push: { followings: req.params.id } });
        res.status(200).json("post has been liked");
        console.log('it has been liked');
        } else {
            res.status(403).json("you have already liked this post");
        }
    } catch (err) {
        res.status(500).json(err);
    }
});

/**
 * @swagger
 * /posts/:id/unlike:
 *   put:
 *     summary: Spesifik Gönderiye getirir.
 *     description: Belirli Id'ye göre gönderiyi getirir.
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
 *            id:
 *               type: string,
 *               required: true
 *     responses:
 *       201:
 *         description: Gönderi getirildi.
 *         schema:
 *           type: object
 *           properties:
 *              id:
 *               type: string,
 *               required: true
 *              file:
 *               type: string,
 *               required: true
 *       400:
 *         description: "Görsel getirilemedi !"
 *       500:
 *         description: "Lütfen daha sonra tekrar deneyiniz"
 */

router.put('/posts/:id/unlike', auth, async (req, res) => {
    try {
        const post = await Posts.findById(req.params.id);
        if (post.likes.includes(req.user.id)) {
        await post.updateOne({ $pull: { likes: req.user.id } });
        // await req.user.updateOne({ $push: { followings: req.params.id } });
        res.status(200).json("post has been unliked");
        } else {
            res.status(403).json("you have already unliked this post");
        }
    } catch (err) {
        res.status(500).json(err);
    }
});

module.exports = router
