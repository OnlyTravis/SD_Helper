import { Router } from "express";
import getFolder from "./getFolder.js";
import getImage from "./getImage.js";
import deleteImages from "./deleteImages.js";

const apiRouter = Router();
apiRouter.use(getFolder);
apiRouter.use(getImage);
apiRouter.use(deleteImages);

export default apiRouter;