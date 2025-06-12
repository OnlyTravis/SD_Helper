import { Router } from "express";
import getFolder from "./getFolder.js";
import getImage from "./getImage.js";
import deleteImages from "./deleteImages.js";
import renameImage from "./renameImage.js";

const apiRouter = Router();
apiRouter.use(getFolder);
apiRouter.use(getImage);
apiRouter.use(deleteImages);
apiRouter.use(renameImage);

export default apiRouter;