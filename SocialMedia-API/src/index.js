const express = require('express')
require("./db/mongoose")    
const userRouter = require('./routers/user')
const postRouter = require('./routers/posts')
const notiRouter = require('./routers/notifications')

const swaggerUi = require("swagger-ui-express")
const swaggerJSDoc = require('swagger-jsdoc')

const app = express()
const port = process.env.PORT || 3000

const options = {
    definition: {
        basepath: '/',
        openapi: '3.0.0',
        info : {
            title: 'Nodejss',
            version: '1.0.0'
        },
        servers: [
            {
              url: 'http://localhost:3000',
            }
          ]
    },
    apis: [`${__dirname}/routers/*.js`]
}

const swaggerSpec = swaggerJSDoc(options)

app.use('/api-doc', swaggerUi.serve, swaggerUi.setup(swaggerSpec))
app.use(express.json())
app.use(userRouter)
app.use(postRouter)
app.use(notiRouter)

app.listen(port, () => { 
    console.log('Server is up on port ' + port)
})
