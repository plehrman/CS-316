printjson(db.people.aggregate([
    { $unwind: "$roles" },

    { $addFields: { state_role: "$roles.state"} },

    { $group: {
        _id: "$_id",
        gender: { $last: "$gender" },
        state: { $last: "$state_role" } } },

    { $group: {
        _id: {state: "$state"},
        M: { $sum: {
            $cond: [{ $eq: ["$gender", "M"]},1,0] }},
        F: { $sum: {
            $cond: [{ $eq: ["$gender", "F"]},1,0] }}}},
    { $project: {
        _id: 0,
        state: "$_id.state",
        M: 1,
        F: 1 }},
    { $sort: {
        state: 1
    }}
    

    ]).toArray());
  
  