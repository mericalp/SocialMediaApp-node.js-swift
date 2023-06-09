const express = require('express')
require("./db/mongoose")    
const userRouter = require('./routers/user')
const postRouter = require('./routers/posts')
const notiRouter = require('./routers/notifications')
const app = express()


const port = process.env.PORT || 3000


app.use(express.json())
app.use(userRouter)
app.use(postRouter)
app.use(notiRouter)

app.listen(port, () => { 
    console.log('Server is up on port ' + port)
})
