printjson(db.committees.aggregate([
    { $match: {"subcommittees.displayname": "Energy and Mineral Resources"}},

    { $unwind: "$subcommittees"},

    { $match: { "subcommittees.displayname": "Energy and Mineral Resources"}},

    { $addFields: {
        chair_member: { $filter: {
        input: "$subcommittees.members",
        as: "member",
        cond: { $regexMatch: { input: "$$member.role"
        , regex: /Ranking Member/ } } } }} },

    { $lookup: { from: "people",
        localField: "chair_member.id",
        foreignField: "_id",
        as: "chair_person"} },
    
    { $unwind: "$chair_person"},
    
    { $replaceRoot: { newRoot: "$chair_person" }}

    ]).toArray())