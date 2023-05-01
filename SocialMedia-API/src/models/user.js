const mongoose = require('mongoose')
const validator = require('validator')
const bcrypt =  require('bcryptjs')
const jwt = require('jsonwebtoken')

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
    tokens:[{
        token:{
            type: String,
            required: true
        }
    }],
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

// Relationship between the tweets and the user 
userSchema.virtual('posts',{
    ref: 'posts',
    localField: '_id',
    foreignField: 'user'
})

userSchema.virtual('notificationSent',{
    ref: 'Notification',
    localField: '_id',
    foreignField: 'notSenderId'
})


userSchema.virtual('notificationReceived',{
    ref: 'Notification',
    localField: '_id',
    foreignField: 'notReceiverId'
})

// Delete Password
userSchema.methods.toJSON = function() { 
    const user = this
    const userObject = user.toObject()
    delete userObject.password
    return userObject
}

// To Hash Password 
userSchema.pre('save', async function(next){
    const user = this
    if(user.isModified('password')){
        user.password = await bcrypt.hash(user.password, 8)
    }

    next()
})


userSchema.methods.generateAuthToken = async function(){
    const user = this 
    const token = jwt.sign({_id: user._id.toString()}, 'socialMedia')

    user.tokens = user.tokens.concat({token})
    await user.save()
    return token
}

// Check Password
userSchema.statics.findByCredentials = async (email, password) => {
    const user = await User.findOne({ email })

    if (!user) {
        throw new Error('Unable to login')
    }

    const isMatch = await bcrypt.compare(password, user.password)

    if (!isMatch) {
        throw new Error('Unable to login')
    }

    return user
}

const User = mongoose.model("User", userSchema)
module.exports = User