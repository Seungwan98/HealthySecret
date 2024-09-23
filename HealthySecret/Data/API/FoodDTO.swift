// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let foodDTO = try? JSONDecoder().decode(FoodDTO.self, from: jsonData)
//   let album = try? JSONDecoder().decode(Album.self, from: jsonData)
//   let track = try? JSONDecoder().decode(Track.self, from: jsonData)

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct FoodDTO: Codable {
    let header: Header
    let body: Body
}

// MARK: - Body
struct Body: Codable {
    let pageNo, totalCount, numOfRows: Int
    let items: [Food]
}

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String
}


// MARK: - FoodDTO
struct Food: Codable {
    let num, foodCD, foodNmKr, dbGrpCM: String?
    let dbGrpNm, foodOrCD, foodOrNm, foodCat1CD: String?
    let foodCat1Nm, foodRefCD, foodRefNm, foodCat2CD: String?
    let foodCat2Nm, foodCat3CD, foodCat3Nm, foodCat4CD: String?
    let foodCat4Nm, servingSize, calorie, amtNum2: String?
    let protein, province, amtNum5, amtNum6: String?
    let carbohydrates, sugars, amtNum9, amtNum10: String?
    let amtNum11, amtNum12, amtNum13, sodium: String?
    let amtNum15, amtNum16, amtNum17, amtNum18: String?
    let amtNum19, amtNum20, amtNum21, amtNum22: String?
    let amtNum23, cholesterol, fattyAcid, transFat: String?
    let amtNum27, amtNum28, amtNum29, amtNum30: String?
    let amtNum31, amtNum32, amtNum33, amtNum34: String?
    let amtNum35, amtNum36, amtNum37, amtNum38: String?
    let amtNum39, amtNum40, amtNum41, amtNum42: String?
    let amtNum43, amtNum44, amtNum45, amtNum46: String?
    let amtNum47, amtNum48, amtNum49, amtNum50: String?
    let amtNum51, amtNum52, amtNum53, amtNum54: String?
    let amtNum55, amtNum56, amtNum57, amtNum58: String?
    let amtNum59, amtNum60, amtNum61, amtNum62: String?
    let amtNum63, amtNum64, amtNum65, amtNum66: String?
    let amtNum67, amtNum68, amtNum69, amtNum70: String?
    let amtNum71, amtNum72, amtNum73, amtNum74: String?
    let amtNum75, amtNum76, amtNum77, amtNum78: String?
    let amtNum79, amtNum80, amtNum81, amtNum82: String?
    let amtNum83, amtNum84, amtNum85, amtNum86: String?
    let amtNum87, amtNum88, amtNum89, amtNum90: String?
    let amtNum91, amtNum92, amtNum93, amtNum94: String?
    let amtNum95, amtNum96, amtNum97, amtNum98: String?
    let amtNum99, amtNum100, amtNum101, amtNum102: String?
    let amtNum103, amtNum104, amtNum105, amtNum106: String?
    let amtNum107, amtNum108, amtNum109, amtNum110: String?
    let amtNum111, amtNum112, amtNum113, amtNum114: String?
    let amtNum115, amtNum116, amtNum117, amtNum118: String?
    let amtNum119, amtNum120, amtNum121, amtNum122: String?
    let amtNum123, amtNum124, amtNum125, amtNum126: String?
    let amtNum127, amtNum128, amtNum129, amtNum130: String?
    let amtNum131, amtNum132, amtNum133, amtNum134: String?
    let amtNum135, amtNum136, amtNum137, amtNum138: String?
    let amtNum139, amtNum140, amtNum141, amtNum142: String?
    let amtNum143, amtNum144, amtNum145, amtNum146: String?
    let amtNum147, amtNum148, amtNum149, amtNum150: String?
    let amtNum151, amtNum152, amtNum153, amtNum154: String?
    let amtNum155, amtNum156, amtNum157, amtNum158: String?
    let amtNum159, amtNum160, amtNum161, amtNum162: String?
    let amtNum163, amtNum164, amtNum165, amtNum166: String?
    let amtNum167, amtNum168, amtNum169, amtNum170: String?
    let amtNum171, amtNum172, amtNum173, amtNum174: String?
    let amtNum175, amtNum176, amtNum177, amtNum178: String?
    let amtNum179, amtNum180, amtNum181, subRefCM: String?
    let subRefName, nutriAmountServing, z10500, itemReportNo: String?
    let makerNm: String?
    let impManufacNm, sellerManufacNm, impYn, nationCM: String?
    let nationNm, crtMthCD, crtMthNm, researchYear: String?
    let updateYmd, name: String?
    let founded: Int?
    let members: [String]?

    enum CodingKeys: String, CodingKey {
        case num = "NUM"
        case foodCD = "FOOD_CD"
        case foodNmKr = "FOOD_NM_KR"
        case dbGrpCM = "DB_GRP_CM"
        case dbGrpNm = "DB_GRP_NM"
        case foodOrCD = "FOOD_OR_CD"
        case foodOrNm = "FOOD_OR_NM"
        case foodCat1CD = "FOOD_CAT1_CD"
        case foodCat1Nm = "FOOD_CAT1_NM"
        case foodRefCD = "FOOD_REF_CD"
        case foodRefNm = "FOOD_REF_NM"
        case foodCat2CD = "FOOD_CAT2_CD"
        case foodCat2Nm = "FOOD_CAT2_NM"
        case foodCat3CD = "FOOD_CAT3_CD"
        case foodCat3Nm = "FOOD_CAT3_NM"
        case foodCat4CD = "FOOD_CAT4_CD"
        case foodCat4Nm = "FOOD_CAT4_NM"
        case servingSize = "SERVING_SIZE"
        case calorie = "AMT_NUM1"
        case amtNum2 = "AMT_NUM2"
        case protein = "AMT_NUM3"
        case province = "AMT_NUM4"
        case amtNum5 = "AMT_NUM5"
        case amtNum6 = "AMT_NUM6"
        case carbohydrates = "AMT_NUM7"
        case sugars = "AMT_NUM8"
        case amtNum9 = "AMT_NUM9"
        case amtNum10 = "AMT_NUM10"
        case amtNum11 = "AMT_NUM11"
        case amtNum12 = "AMT_NUM12"
        case amtNum13 = "AMT_NUM13"
        case sodium = "AMT_NUM14"
        case amtNum15 = "AMT_NUM15"
        case amtNum16 = "AMT_NUM16"
        case amtNum17 = "AMT_NUM17"
        case amtNum18 = "AMT_NUM18"
        case amtNum19 = "AMT_NUM19"
        case amtNum20 = "AMT_NUM20"
        case amtNum21 = "AMT_NUM21"
        case amtNum22 = "AMT_NUM22"
        case amtNum23 = "AMT_NUM23"
        case cholesterol = "AMT_NUM24"
        case fattyAcid = "AMT_NUM25"
        case transFat = "AMT_NUM26"
        case amtNum27 = "AMT_NUM27"
        case amtNum28 = "AMT_NUM28"
        case amtNum29 = "AMT_NUM29"
        case amtNum30 = "AMT_NUM30"
        case amtNum31 = "AMT_NUM31"
        case amtNum32 = "AMT_NUM32"
        case amtNum33 = "AMT_NUM33"
        case amtNum34 = "AMT_NUM34"
        case amtNum35 = "AMT_NUM35"
        case amtNum36 = "AMT_NUM36"
        case amtNum37 = "AMT_NUM37"
        case amtNum38 = "AMT_NUM38"
        case amtNum39 = "AMT_NUM39"
        case amtNum40 = "AMT_NUM40"
        case amtNum41 = "AMT_NUM41"
        case amtNum42 = "AMT_NUM42"
        case amtNum43 = "AMT_NUM43"
        case amtNum44 = "AMT_NUM44"
        case amtNum45 = "AMT_NUM45"
        case amtNum46 = "AMT_NUM46"
        case amtNum47 = "AMT_NUM47"
        case amtNum48 = "AMT_NUM48"
        case amtNum49 = "AMT_NUM49"
        case amtNum50 = "AMT_NUM50"
        case amtNum51 = "AMT_NUM51"
        case amtNum52 = "AMT_NUM52"
        case amtNum53 = "AMT_NUM53"
        case amtNum54 = "AMT_NUM54"
        case amtNum55 = "AMT_NUM55"
        case amtNum56 = "AMT_NUM56"
        case amtNum57 = "AMT_NUM57"
        case amtNum58 = "AMT_NUM58"
        case amtNum59 = "AMT_NUM59"
        case amtNum60 = "AMT_NUM60"
        case amtNum61 = "AMT_NUM61"
        case amtNum62 = "AMT_NUM62"
        case amtNum63 = "AMT_NUM63"
        case amtNum64 = "AMT_NUM64"
        case amtNum65 = "AMT_NUM65"
        case amtNum66 = "AMT_NUM66"
        case amtNum67 = "AMT_NUM67"
        case amtNum68 = "AMT_NUM68"
        case amtNum69 = "AMT_NUM69"
        case amtNum70 = "AMT_NUM70"
        case amtNum71 = "AMT_NUM71"
        case amtNum72 = "AMT_NUM72"
        case amtNum73 = "AMT_NUM73"
        case amtNum74 = "AMT_NUM74"
        case amtNum75 = "AMT_NUM75"
        case amtNum76 = "AMT_NUM76"
        case amtNum77 = "AMT_NUM77"
        case amtNum78 = "AMT_NUM78"
        case amtNum79 = "AMT_NUM79"
        case amtNum80 = "AMT_NUM80"
        case amtNum81 = "AMT_NUM81"
        case amtNum82 = "AMT_NUM82"
        case amtNum83 = "AMT_NUM83"
        case amtNum84 = "AMT_NUM84"
        case amtNum85 = "AMT_NUM85"
        case amtNum86 = "AMT_NUM86"
        case amtNum87 = "AMT_NUM87"
        case amtNum88 = "AMT_NUM88"
        case amtNum89 = "AMT_NUM89"
        case amtNum90 = "AMT_NUM90"
        case amtNum91 = "AMT_NUM91"
        case amtNum92 = "AMT_NUM92"
        case amtNum93 = "AMT_NUM93"
        case amtNum94 = "AMT_NUM94"
        case amtNum95 = "AMT_NUM95"
        case amtNum96 = "AMT_NUM96"
        case amtNum97 = "AMT_NUM97"
        case amtNum98 = "AMT_NUM98"
        case amtNum99 = "AMT_NUM99"
        case amtNum100 = "AMT_NUM100"
        case amtNum101 = "AMT_NUM101"
        case amtNum102 = "AMT_NUM102"
        case amtNum103 = "AMT_NUM103"
        case amtNum104 = "AMT_NUM104"
        case amtNum105 = "AMT_NUM105"
        case amtNum106 = "AMT_NUM106"
        case amtNum107 = "AMT_NUM107"
        case amtNum108 = "AMT_NUM108"
        case amtNum109 = "AMT_NUM109"
        case amtNum110 = "AMT_NUM110"
        case amtNum111 = "AMT_NUM111"
        case amtNum112 = "AMT_NUM112"
        case amtNum113 = "AMT_NUM113"
        case amtNum114 = "AMT_NUM114"
        case amtNum115 = "AMT_NUM115"
        case amtNum116 = "AMT_NUM116"
        case amtNum117 = "AMT_NUM117"
        case amtNum118 = "AMT_NUM118"
        case amtNum119 = "AMT_NUM119"
        case amtNum120 = "AMT_NUM120"
        case amtNum121 = "AMT_NUM121"
        case amtNum122 = "AMT_NUM122"
        case amtNum123 = "AMT_NUM123"
        case amtNum124 = "AMT_NUM124"
        case amtNum125 = "AMT_NUM125"
        case amtNum126 = "AMT_NUM126"
        case amtNum127 = "AMT_NUM127"
        case amtNum128 = "AMT_NUM128"
        case amtNum129 = "AMT_NUM129"
        case amtNum130 = "AMT_NUM130"
        case amtNum131 = "AMT_NUM131"
        case amtNum132 = "AMT_NUM132"
        case amtNum133 = "AMT_NUM133"
        case amtNum134 = "AMT_NUM134"
        case amtNum135 = "AMT_NUM135"
        case amtNum136 = "AMT_NUM136"
        case amtNum137 = "AMT_NUM137"
        case amtNum138 = "AMT_NUM138"
        case amtNum139 = "AMT_NUM139"
        case amtNum140 = "AMT_NUM140"
        case amtNum141 = "AMT_NUM141"
        case amtNum142 = "AMT_NUM142"
        case amtNum143 = "AMT_NUM143"
        case amtNum144 = "AMT_NUM144"
        case amtNum145 = "AMT_NUM145"
        case amtNum146 = "AMT_NUM146"
        case amtNum147 = "AMT_NUM147"
        case amtNum148 = "AMT_NUM148"
        case amtNum149 = "AMT_NUM149"
        case amtNum150 = "AMT_NUM150"
        case amtNum151 = "AMT_NUM151"
        case amtNum152 = "AMT_NUM152"
        case amtNum153 = "AMT_NUM153"
        case amtNum154 = "AMT_NUM154"
        case amtNum155 = "AMT_NUM155"
        case amtNum156 = "AMT_NUM156"
        case amtNum157 = "AMT_NUM157"
        case amtNum158 = "AMT_NUM158"
        case amtNum159 = "AMT_NUM159"
        case amtNum160 = "AMT_NUM160"
        case amtNum161 = "AMT_NUM161"
        case amtNum162 = "AMT_NUM162"
        case amtNum163 = "AMT_NUM163"
        case amtNum164 = "AMT_NUM164"
        case amtNum165 = "AMT_NUM165"
        case amtNum166 = "AMT_NUM166"
        case amtNum167 = "AMT_NUM167"
        case amtNum168 = "AMT_NUM168"
        case amtNum169 = "AMT_NUM169"
        case amtNum170 = "AMT_NUM170"
        case amtNum171 = "AMT_NUM171"
        case amtNum172 = "AMT_NUM172"
        case amtNum173 = "AMT_NUM173"
        case amtNum174 = "AMT_NUM174"
        case amtNum175 = "AMT_NUM175"
        case amtNum176 = "AMT_NUM176"
        case amtNum177 = "AMT_NUM177"
        case amtNum178 = "AMT_NUM178"
        case amtNum179 = "AMT_NUM179"
        case amtNum180 = "AMT_NUM180"
        case amtNum181 = "AMT_NUM181"
        case subRefCM = "SUB_REF_CM"
        case subRefName = "SUB_REF_NAME"
        case nutriAmountServing = "NUTRI_AMOUNT_SERVING"
        case z10500 = "Z10500"
        case itemReportNo = "ITEM_REPORT_NO"
        case makerNm = "MAKER_NM"
        case impManufacNm = "IMP_MANUFAC_NM"
        case sellerManufacNm = "SELLER_MANUFAC_NM"
        case impYn = "IMP_YN"
        case nationCM = "NATION_CM"
        case nationNm = "NATION_NM"
        case crtMthCD = "CRT_MTH_CD"
        case crtMthNm = "CRT_MTH_NM"
        case researchYear = "RESEARCH_YMD"
        case updateYmd = "UPDATE_YMD"
        case name, founded, members
    }
}

