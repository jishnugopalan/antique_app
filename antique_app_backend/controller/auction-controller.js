const { json } = require("body-parser")
const Auction=require("../model/auction")

exports.addAuctionItem=(req,res)=>{
    console.log("in")
    console.log(req.body)
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

exports.getAllAuction=(req,res)=>{
    Auction.find().then((auction)=>{
        if(auction){
            return res.status(201).json(auction)
        }
        else{
            return res.status(404).json({msg:"Error"})
        }
    })
}

exports.getAuctionByShopid=(req,res)=>{
    Auction.find({shop:req.body.shopid}).populate('bids.bidder').then((auction)=>{
        if(auction){
            return res.status(201).json(auction)
        }
        else{
            return res.status(404).json({msg:"Error"})
        }
    })
}

exports.getAuctionById=(req,res)=>{
    Auction.findOne({_id:req.body.auctionid}).populate('shop').populate('bids.bidder').then((auction)=>{
        if(auction){
            return res.status(201).json(auction)
        }
        else{
            return res.status(404).json({msg:"Error"})
        }
    })
}

exports.deleteAuctionById=(req,res)=>{
    Auction.deleteOne({_id:req.body.auctionid}).then((auction)=>{
        if(auction){
            return res.status(201).json(auction)
        }
        else{
            return res.status(404).json({msg:"Error"})
        }
    })
}

exports.updateAuctionStatus=(req,res)=>{
    console.log(req.body)
    Auction.updateOne({_id:req.body.auctionid},{
        $set:{
            availability:req.body.status
        }
    }).then((auction)=>{
        if(auction){
            return res.status(201).json(auction)
        }
        else{
            return res.status(404).json({msg:"Error"})
        }
    })
}

exports.updateBid=(req,res)=>{
    //auction = Auction.findById(req.body.auctionid);
    Auction.findOne({_id:req.body.auctionid}).then((auction)=>{
        if(auction){
            

       auction.bids.push({
            bidder:req.body.bidder,
            bidAmount:req.body.bidAmount,
            bidTime:new Date()
        })
        auction.save().then((upd)=>{
            if(upd){

                return res.status(201).json(upd)
            }
            else{
            return res.status(404).json({msg:"Error"})

            }
        })

        console.log(auction)


        }else{
            return res.status(404).json({msg:"Error"})
        }
    })
}

// exports.getHighestBidByAuctionId=(req,res)=>{
//     Auction.updateOne({_id:req.body.auctionid}).populate('bids.bidder').then((auction)=>{
//         if(auction){
//             if (auction.bids.length === 0) {
//                 return res.status(404).json({msg:"no bid"}); // Return null if there are no bids
//             }
//             else{
//                 const highestBid = auction.bids.reduce((maxBid, currentBid) => {
//                     return currentBid.bidAmount > maxBid.bidAmount ? currentBid : maxBid;
//                   });
//                 return res.status(201).json(highestBid)
//             }
//         }
//         else{
//             return res.status(404).json({msg:"Error"})
//         }
//     })
// }