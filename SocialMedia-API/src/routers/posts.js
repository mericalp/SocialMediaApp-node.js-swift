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

// Specific Fetch post
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



// Post like and unlike
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