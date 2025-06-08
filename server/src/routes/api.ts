import { Router } from "express";

const apiRouter = Router();

apiRouter.get("/getFolder", (req, res) => {
    console.log("getting folder");
    console.log(req.url)
    console.log(req.session)
    res.status(200).send();
});

export default apiRouter;