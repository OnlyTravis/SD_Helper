import { Application } from 'express';

import loginRouter from './login.js';
import authRouter from './auth.js';
import apiRouter from './api/index.js';


export function applyRouters(app: Application) {
    app.use(loginRouter);
    app.use(authRouter);
    app.use("/api", apiRouter);
}