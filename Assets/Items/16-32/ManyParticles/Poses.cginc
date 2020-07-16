static float3 nop =  float3(10000,10000,10000);
static float3 nopos[3] = {
	nop,
	nop,
	nop,
};
static float3 noposbeat[4][3] = {
	nopos,
	nopos,
	nopos,
	nopos,
};
static float3 poses[19][3] = {
	{
		float3(-30, 0, 30),
		float3(30, 0, -30),
		nop,
	},
	{
		float3(30, 0, -30),
		float3(-30, 0, 30),
		nop,
	},
	{
		float3(20, 40, 20),
		float3(-20, 40, 20),
		float3(0, 40, -20),
	},
	{
		float3(20, -40, 20),
		float3(-20, -40, 20),
		float3(0, -40, -20),
	}, // End
	{
		float3(20, 40, 20),
		float3(-20, -40, 20),
		float3(0, -40, -20),
	},
	{
		float3(-20, 50, -20),
		float3(-20, 30, 20),
		float3(30, -40, -20),
	},
	{
		float3(20, 0, 30),
		float3(-20, -50, -20),
		float3(-50, -40, -50),
	},
	{
		float3(20, -40, 20),
		float3(-20, 50, 20),
		float3(0, -40, -20),
	},
	{
		float3(20, 20, 20),
		float3(-20, -50, -10),
		float3(-20, 0, -40),
	},
	{
		float3(50, -20, 20),
		float3(-20, 0, -30),
		float3(-20, +40, 0),
	},
	{
		float3(20, -40, -20),
		float3(-20, 50, 30),
		float3(0, 40, -20),
	},
	{
		float3(0, -0, 20),
		float3(-20, 0, 20),
		float3(0, -40, -20),
	},
	{
		float3(20, 30, 20),
		float3(-20, -40, 20),
		float3(0, -40, -50),
	},
	{
		float3(20, -40, 20),
		float3(-20, -40, 20),
		float3(0, -40, -20),
	},
	{
		float3(20, -40, 20),
		float3(-20, -40, 20),
		float3(0, -40, -20),
	},
	{
		float3(20, -0, 20),
		float3(20, -0, -20),
		float3(0, -0, -20),
	},
	{
		float3(20, 40, 20),
		float3(-20, 40, 20),
		float3(0, 40, -20),
	},
	{
		float3(20, 40, 20),
		float3(0, 40, 0),
		float3(0, 40, 0),
	},
	{
		float3(20, -30, 50),
		float3(-10, -30, 30),
		float3(0, -30, -20),
	},
};

static float3 poses1[4][8][3] = {
	{
		{
			float3(-20, -20, 20),
			float3(-30, -40, 20),
			nop,
		},
		{
			float3(20, -20, 20),
			float3(30, -40, 30),
			nop,
		},
		{
			float3(20, -20, -30),
			float3(30, -40, -20),
			nop,
		},
		{
			float3(-30, -10, -10),
			float3(-20, -30, -20),
			nop,
		},
		{
			float3(-20, 30, 30),
			float3(-10, 20, 20),
			nop,
		},
		{
			float3(20, 30, 20),
			float3(10, 20, 20),
			nop,
		},
		{
			float3(0, 0, 30),
			float3(0, 10, 30),
			nop,
		},
		nopos,
	},
	{
		{
			float3(-20, 30, 20),
			float3(-20, 30, -20),
			float3(30, 30, 20),
		},
		{
			float3(20, 10, 20),
			float3(-20, 10, -20),
			float3(-30, 10, 20),
		},
		{
			float3(20, -10, -20),
			float3(-20, -10, 20),
			float3(-30, -10, 20),
		},
		{
			float3(20, -30, -20),
			float3(-20, -30, 20),
			float3(30, -30, -20),
		},
		nopos,
		nopos,
		nopos,
		nopos,
	},
	{
		{
			float3(20, 30, -20),
			float3(10, 40, -29),
			float3(-25,23,-22),
		},
		{
			float3(-23,42, -34),
			float3(23,-33, -0),
			float3(0, -32, 0),
		},
		{
			float3(35,-21,-10),
			float3(-10,29,15),
			float3(-32,41,-10),
		},
		{
			float3(-12,-21,23),
			float3(0, 0, -12),
			float3(-32,12,23),
		},
		{
			float3(23, -12, 22),
			float3(-20,-22,0),
			float3(-23,-30,41),
		},
		{
			float3(23,-21,11),
			float3(32,-23,32),
			float3(32,-32,32),
		},
		{
			float3(23,21,-11),
			float3(-32,23,32),
			float3(32,32,32),
		},
		{
			float3(23,0,-11),
			float3(32,0,32),
			float3(32,0,32),
		},
	},
	{
		{
			float3(-12, 32, -12),
			float3(20, 23, 12),
			float3(-12, 15, 23),
		},
		{
			float3(12, -32, -12),
			float3(-20, -23, 12),
			float3(12, -15, -23),
		},
		nopos,
		nopos,
		nopos,
		nopos,
		nopos,
		nopos,
	},
};
static float3 posroute[16][4][4][3] = {
	{ // Bar0
		noposbeat,
		{ // Beat1
			poses[0],
			poses[0],
			nopos,
			poses[1],
		},
		{
			poses[2],
			poses[3],
			poses[3],
			nopos,
		},
		{
			nopos,
			nopos,
			poses[4],
			poses[4],
		},
	},
	{
		{
			poses[5],
			poses[5],
			nopos,
			poses[6],
		},
		{
			poses[7],
			poses[7],
			nopos,
			nopos,
		},
		{
			poses[8],
			nopos,
			nopos,
			poses[9],
		},
		{
			poses[10],
			poses[10],
			poses[11],
			poses[11],
		},
	},
	{
		{
			poses[12],
			poses[12],
			nopos,
			poses[13],
		},
		noposbeat,
		{
			nopos,
			nopos,
			poses[14],
			poses[14],
		},
		{
			poses[15],
			poses[15],
			poses[16],
			poses[16],
		},
	},
	{
		{
			poses[17],
			poses[17],
			poses[17],
			poses[17],
		},
		{
			poses[17],
			poses[17],
			poses[17],
			poses[17],
		},
		{
			poses[18],
			poses[18],
			poses[18],
			poses[18],
		},
		{
			poses[18],
			poses[18],
			poses[18],
			poses[18],
		},
	},
	{ // Bar4
		noposbeat,
		{
			poses1[0][0],
			poses1[0][1],
			poses1[0][2],
			poses1[0][3],
		},
		{
			poses1[0][4],
			nopos,
			poses1[0][5],
			nopos,
		},
		{
			poses1[0][6],
			poses1[0][6],
			poses1[0][6],
			nopos,
		},
	},
	{
		{
			poses1[1][0],
			poses1[1][0],
			nopos,
			nopos,
		},
		{
			poses1[1][1],
			poses1[1][1],
			nopos,
			nopos,
		},
		{
			poses1[1][2],
			poses1[1][2],
			nopos,
			nopos,
		},
		{
			poses1[1][3],
			poses1[1][3],
			nopos,
			nopos,
		},
	},
	{
		{
			poses1[2][0],
			poses1[2][0],
			poses1[2][1],
			poses1[2][1],
		},
		{
			poses1[2][2],
			poses1[2][2],
			poses1[2][3],
			poses1[2][3],
		},
		{
			poses1[2][4],
			poses1[2][4],
			poses1[2][5],
			poses1[2][5],
		},
		{
			poses1[2][6],
			poses1[2][6],
			poses1[2][7],
			poses1[2][7],
		},
	},
	{
		{
			poses1[3][0],
			poses1[3][0],
			poses1[3][0],
			poses1[3][0],
		},
		{
			poses1[3][1],
			poses1[3][1],
			poses1[3][1],
			poses1[3][1],
		},
		noposbeat,
		noposbeat,
	},
	{ // Bar8
		noposbeat,
		{ // Beat1
			poses[0],
			poses[0],
			nopos,
			poses[1],
		},
		{
			poses[2],
			poses[3],
			poses[3],
			nopos,
		},
		{
			nopos,
			nopos,
			poses[4],
			poses[4],
		},
	},
	{
		{
			poses[5],
			poses[5],
			nopos,
			poses[6],
		},
		{
			poses[7],
			poses[7],
			nopos,
			nopos,
		},
		{
			poses[8],
			nopos,
			nopos,
			poses[9],
		},
		{
			poses[10],
			poses[10],
			poses[11],
			poses[11],
		},
	},
	{
		{
			poses[12],
			poses[12],
			nopos,
			poses[13],
		},
		noposbeat,
		{
			nopos,
			nopos,
			poses[14],
			poses[14],
		},
		{
			poses[15],
			poses[15],
			poses[16],
			poses[16],
		},
	},
	{
		{
			poses[17],
			poses[17],
			poses[17],
			poses[17],
		},
		{
			poses[17],
			poses[17],
			poses[17],
			poses[17],
		},
		{
			poses[18],
			poses[18],
			poses[18],
			poses[18],
		},
		{
			poses[18],
			poses[18],
			poses[18],
			poses[18],
		},
	},
	{ // Bar12
		noposbeat,
		noposbeat,
		noposbeat,
		noposbeat,
	},
	{ 
		noposbeat,
		noposbeat,
		noposbeat,
		noposbeat,
	},
	{ 
		noposbeat,
		noposbeat,
		noposbeat,
		noposbeat,
	},
	{ 
		noposbeat,
		noposbeat,
		noposbeat,
		noposbeat,
	},
};
		/*
		{ // Beat1
			poses[0],
			poses[0],
			nopos,
			poses[1],
		},
		{
			poses[2],
			poses[3],
			poses[3],
			nopos,
		},
		{
			nopos,
			nopos,
			poses[4],
			poses[4],
		},
	},
	{
		{
			poses[5],
			poses[5],
			nopos,
			poses[6],
		},
		{
			poses[7],
			poses[7],
			nopos,
			nopos,
		},
		{
			poses[8],
			nopos,
			nopos,
			poses[9],
		},
		{
			poses[10],
			poses[10],
			poses[11],
			poses[11],
		},
	},
	{
		{
			poses[12],
			poses[12],
			nopos,
			poses[13],
		},
		noposbeat,
		{
			nopos,
			nopos,
			poses[14],
			poses[14],
		},
		{
			poses[15],
			poses[15],
			poses[16],
			poses[16],
		},
	},
	{
		{
			poses[17],
			poses[17],
			poses[17],
			poses[17],
		},
		{
			poses[17],
			poses[17],
			poses[17],
			poses[17],
		},
		{
			poses[18],
			poses[18],
			poses[18],
			poses[18],
		},
		{
			poses[18],
			poses[18],
			poses[18],
			poses[18],
		},
	},
};
*/
