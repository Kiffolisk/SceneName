import json
import net.http
import os

fn main() {
    println("PG3D Length-Equivalent Scene Name Getter")
    println("(1) download json file")
    println("(2) get the maps")
    println("(3) get every swap possible")
    println("(4) make json file with bundle data\n")
    print("choice: ")
    mut choice := os.get_line()
    if choice == "1" {
        resp := http.get('https://raw.githubusercontent.com/YeetDisDude/pixel-gun-3d/main/map%20list.txt')?
        mut realtext := resp.text
        realtext = realtext.replace('"maxV": "15.0.0.0",', '"maxV": "15.0.0.0"')
        realtext = realtext.replace("}\n", "},\n")
        realtext = "{" + realtext.find_between("{", "]") + "]\n}"
        realtext = realtext.replace("},\n\t]", "}\n\t]")
        os.write_file("./mapdata.json", realtext)?
        println("saved")
    }else if choice == "2" {
        // resp := http.get('https://raw.githubusercontent.com/YeetDisDude/pixel-gun-3d/main/map%20list.txt')?
        mut mapdat := os.read_file("./mapdata.json") or { panic("please use option 1 first") }
        // mut mapdatas := json2.raw_decode(resp.text) or { panic(err) }
        // mut mapdatas := json2.raw_decode(mapdat)?
        // mut mapdata := mapdatas.as_map()
        mapdata := json.decode(map[string][]map[string]string, mapdat)?
        print("\ntype a number for length (use https://wordcounter.net/): ")
        mut length := os.get_line()
        // mut mydata := mapdata["allAvaliableMap"].arr()
        mut mydata := mapdata["allAvaliableMap"]
        println("\nfinding options for length " + length)
        for amap in mydata {
            if amap["nameScene"].str().len == length.int() {
                println(amap["nameScene"].str())
            }
        }
    }else if choice == "3" {
        mut mapdat := os.read_file("./mapdata.json") or { panic("please use option 1 first") }
        mapdata := json.decode(map[string][]map[string]string, mapdat)?
        mut mydata := mapdata["allAvaliableMap"]
        println("\nfinding all possible swaps")
        for amap in mydata {
            my := amap["nameScene"]
            for amap2 in mydata {
                if amap2["nameScene"].str().len == my.len && amap2["nameScene"] != my {
                    println(my + " -> " + amap2["nameScene"].str())
                }
            }
        }
    }else{
        println("invalid option")
    }
}
