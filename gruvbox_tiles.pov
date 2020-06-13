// To render:
//
// povray -D +Q11 +A Width=3440 Height=1600 gruvbox_tiles.pov

#include "colors.inc"

#declare GB_BG0_Hard    = rgb <0.014, 0.025, 0.029>;
#declare GB_Dark_Red    = rgb <0.800, 0.141, 0.114>;
#declare GB_Dark_Green  = rgb <0.596, 0.592, 0.102>;
#declare GB_Dark_Yellow = rgb <0.843, 0.600, 0.129>;
#declare GB_Dark_Blue   = rgb <0.271, 0.522, 0.533>;
#declare GB_Dark_Purple = rgb <0.694, 0.243, 0.525>;
#declare GB_Dark_Aqua   = rgb <0.408, 0.616, 0.416>;
#declare GB_Dark_Orange = rgb <0.839, 0.365, 0.055>;

#declare GB_Gray        = rgb <0.573, 0.514, 0.455>;
#declare GB_Fg          = rgb <0.922, 0.859, 0.698>;

#declare GB_Lite_Red    = rgb <0.984, 0.286, 0.204>;
#declare GB_Lite_Green  = rgb <0.722, 0.733, 0.149>;
#declare GB_Lite_Yellow = rgb <0.980, 0.741, 0.184>;
#declare GB_Lite_Blue   = rgb <0.514, 0.647, 0.596>;
#declare GB_Lite_Purple = rgb <0.827, 0.525, 0.608>;
#declare GB_Lite_Orange = rgb <0.996, 0.502, 0.098>;

camera {
    location <5, 2, -42>
    look_at <30, 17, 0>
}

light_source {
    <10, 30, -20> color GB_Lite_Purple
    spotlight
    point_at <39, 17, 0>
}

#declare Tile_Size = 0.8;
#declare Tile_Spacing = 1;
#declare Tile_Thickness = 0.4;

#macro Tile_Box(Xt, Yt)
    #local Lx = Xt*(Tile_Size+Tile_Spacing);
    #local Ly = Yt*(Tile_Size+Tile_Spacing);
    #local Ux = (Xt*(Tile_Size+Tile_Spacing))+Tile_Size;
    #local Uy = (Yt*(Tile_Size+Tile_Spacing))+Tile_Size;
    <Lx, Ly, 0>, <Ux, Uy, Tile_Thickness>
#end

#declare Index = 0;
#while (Index < 80)
    #declare Row = 0;
    #while (Row < 2)
        box {
            Tile_Box(Index, Row)
            texture {
                pigment { color GB_BG0_Hard }
            }
        }
        #declare Row = Row + 1;
    #end

    box {
        Tile_Box(Index, Row)
        material {
            texture {
                pigment { color GB_Dark_Red }
            }
        }
    }
    #declare Row = Row + 1;

    box {
        Tile_Box(Index, Row)
        texture {
            pigment { color GB_Lite_Red }
        }
    }
    #declare Row = Row + 1;

    box {
        Tile_Box(Index, Row)
        texture {
            pigment { color GB_Lite_Green }
        }
    }
    #declare Row = Row + 1;

    box {
        Tile_Box(Index, Row)
        texture {
            pigment { color GB_Dark_Green }
        }
    }
    #declare Row = Row + 1;

    #while (Row < 8)
        box {
            Tile_Box(Index, Row)
            texture {
                pigment { color GB_BG0_Hard }
            }
        }
        #declare Row = Row + 1;
    #end
    
    box {
        Tile_Box(Index, Row)
        texture {
            pigment { color GB_Dark_Yellow }
        }
    }
    #declare Row = Row + 1;
    
    box {
        Tile_Box(Index, Row)
        texture {
            pigment { color GB_Lite_Yellow }
        }
    }
    #declare Row = Row + 1;
    
    box {
        Tile_Box(Index, Row)
        texture {
            pigment { color GB_Lite_Purple }
        }
    }
    #declare Row = Row + 1;
    
    box {
        Tile_Box(Index, Row)
        texture {
            pigment { color GB_Dark_Purple }
        }
    }
    #declare Row = Row + 1;

    #while (Row < 14)
        box {
            Tile_Box(Index, Row)
            texture {
                pigment { color GB_BG0_Hard }
            }
        }
        #declare Row = Row + 1;
    #end
    
    box {
        Tile_Box(Index, Row)
        texture {
            pigment { color GB_Dark_Orange }
        }
    }
    #declare Row = Row + 1;
    
    box {
        Tile_Box(Index, Row)
        texture {
            pigment { color GB_Lite_Orange }
        }
    }
    #declare Row = Row + 1;
    
    box {
        Tile_Box(Index, Row)
        texture {
            pigment { color GB_Lite_Blue }
        }
    }
    #declare Row = Row + 1;
    
    box {
        Tile_Box(Index, Row)
        texture {
            pigment { color GB_Dark_Blue }
        }
    }
    #declare Row = Row + 1;
    
    #while (Row < 20)
        box {
            Tile_Box(Index, Row)
            texture {
                pigment { color GB_BG0_Hard }
            }
        }
        #declare Row = Row + 1;
    #end
#declare Index = Index + 1;
#end
