const mongoose = require('mongoose')

const postsSchema = new mongoose.Schema({
    text: {
        type: String,
        required: true,
        trim: true
    },
    user: {
        type: String,
        required: true
    },
    username: { 
        type: String,
        required: true,
        trim: true
    },
    userId: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'User'
    },
    image: {
        type: Buffer
    },
    likes: {
        type: Array,
        default: []
     }
}, {
    timestamps: true
})

const Posts = mongoose.model('Posts', postsSchema)
module.exports = Posts