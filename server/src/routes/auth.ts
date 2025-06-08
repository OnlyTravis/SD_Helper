import { Router } from "express"

const authRouter = Router();

authRouter.all("/api/{*any}", (req, res, next) => {
    console.log(req.session);
    next();
});

export default authRouter;