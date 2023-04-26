const mongoose = require('mongoose')
const validator = require('validator')

const userSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        trim: true
    },
    username: {
        type: String,
        required: true,
        trim: true,
        unique: true
    },
    email: {
        type: String,
        unique: true,
        required: true,
        trim: true,
        lowercase: true,
        validate(value){
            if(!validator.isEmail(value)){
                throw new Error('Mail not valid')
            }
        }
    },
    password: { 
        type: String,
        required: true,
        trim: true,
        validate(value){
            if(value.toLowerCase().includes('password')){
                throw new Error('The password cannot be entered in the password.')
            }
        }
    },
    avatar: { 
        type: Buffer
    },
    avatarExists: { 
        type: Boolean
    },
    bio: {
        Type: String
    },
    website: {
        type: String
    },
    location: {
        type: String
    },
    followers: {
        type: Array,
        default: []
    },
    followings: {
        type: Array,
        default: []
    }
})

const User = mongoose.model("User", userSchema)
module.exports = User