const express = require('express')
require("./db/mongoose")    
const userRouter = require('./routers/user')
const postRouter = require('./routers/posts')
const notiRouter = require('./routers/notifications')
const app = express()


const port = process.env.PORT || 3000


app.use(express.json())
app.use(userRouter)
app.use(notiRouter)
app.use(postRouter)

app.listen(port, () => { 
    console.log('Server is up on port ' + port)
})
