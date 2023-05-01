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

// upload post
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

// Upload post image
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

// Fetch posts
router.get('/posts', async (req, res) => {
    try { 
        const posts = await Posts.find({})
        res.send(posts)
    } catch(e) {
        res.status(400).send(e)
    }
})

// Fetch post image 
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

module.exports = router