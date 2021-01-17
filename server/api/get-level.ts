//import { NowRequest, NowResponse } from "@vercel/node";

export default function handler(req, res) {
    res.statusCode = 200
    res.setHeader('Content-Type', 'application/json')
    res.end(
      JSON.stringify({
        title: 'Twisted Kingdom Test',
        thumbnailUrls: ['dlc01_thumbnail.png'],
        scene: 'dlc01_scene',
        deps: ['dlc01_assets'],
      }),
    )
  }
  