const Auction=require("../model/auction")

exports.addAuctionItem=(req,res)=>{
    let newAuction=Auction(req.body)
    newAuction.save().then((auction)=>{
        if(auction){
            return res.status(201).json(auction)
        }
        else{
            return res.status(404).json({msg:"Error"})
        }
    })
}