import { Application } from 'express';

import loginRouter from './login';

export function applyRouters(app: Application) {
    app.use("/", loginRouter);
}