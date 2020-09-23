import { NowRequest, NowResponse } from "@vercel/node";

interface GetGameResponse {
  canPlay: true;
  levelId: number;
  levelName: string;
  buildUrl: string;
  thumbnailUrl?: string;
}

export default (request: NowRequest, response: NowResponse) => {
  const resp: GetGameResponse = {
    canPlay: true,
    levelId: 1,
    levelName: "Twisted Kingdom",
    buildUrl: "https://davidbyttow.com/impossiblegames/assetbundles/dlctest01",
  };
  response.status(200).send(resp);
};
