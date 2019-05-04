// import Vue from 'vue';

const state = {
  Vessels: [],
  loadingVesselsTable: false,
  hideUtil: 'true', // '@UtilVesselFilter@',
};
const getters = {
  loadingVesselsTable: state => {
    return state.loadingVesselsTable;
  },
  GET_VESSELS_LIST: state => {
    return state.Vessels;
  },
  GET_FILTER_HIDE: state => {
    return state.hideUtil;
  },
};
const mutations = {
  loadVessels: (state, payload) => {
    state.Vessels = payload;
  },
  MUTATION_TABLE_REMOVE_OLD: (state, payload) => {
    let conditionValOld = document.getElementById(payload).parentElement.firstElementChild.textContent;
    let locationValOld = document.getElementById(payload).parentElement.parentElement.firstElementChild.textContent;

    let headerIndex_mode = state.Vessels.findIndex(function(block) {
      return block.Location === locationValOld;
    });

    let subHeaderIndex_mode = state.Vessels[headerIndex_mode].ConditionDetails.findIndex(function(block) {
      return block.Condition === conditionValOld;
    });
    let vesselIndex = state.Vessels[headerIndex_mode].ConditionDetails[subHeaderIndex_mode].VesselDetails.findIndex(
      function(block) {
        return block.ID === payload;
      }
    );

    state.Vessels[headerIndex_mode].ConditionDetails[subHeaderIndex_mode].VesselDetails.splice(vesselIndex, 1);
    /*MEMO: Удалить заголовок, если больше ничего нет*/
    if (state.Vessels[headerIndex_mode].ConditionDetails[subHeaderIndex_mode].VesselDetails.length === 0) {
      state.Vessels[headerIndex_mode].ConditionDetails.splice(subHeaderIndex_mode, 1);
    }
    /*MEMO: Удалить локацию, если больше ничего нет*/
    if (state.Vessels[headerIndex_mode].ConditionDetails.length === 0) {
      state.Vessels.splice(headerIndex_mode, 1);
    }
  },
  MUTATION_TABLE_UPDATE: (state, payload) => {
    let headerIndex = state.Vessels.findIndex(function(block) {
      return block.Location === payload.Location;
    });

    if (headerIndex !== -1) {
      let subHeaderIndex = state.Vessels[headerIndex].ConditionDetails.findIndex(function(block) {
        return block.Condition === payload.ConditionDetails[0].Condition;
      });

      if (subHeaderIndex !== -1) {
        let vesselIndex = state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.findIndex(function(
          block
        ) {
          return block.ID === payload.ConditionDetails[0].VesselDetails[0].ID;
        });

        if (vesselIndex !== -1) {
          state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.splice(vesselIndex, 1);
          state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.unshift(
            payload.ConditionDetails[0].VesselDetails[0]
          );
        } else {
          state.Vessels[headerIndex].ConditionDetails[subHeaderIndex].VesselDetails.unshift(
            payload.ConditionDetails[0].VesselDetails[0]
          );
        } /*vesselIndex END*/
      } else {
        state.Vessels[headerIndex].ConditionDetails.unshift(payload.ConditionDetails[0]);
      } /*subHeaderIndex END*/
    } else {
      state.Vessels.unshift(payload);
    } /*headerIndex END*/
  },
};
const actions = {
  loadVessels: ({ commit }, payload) => {
    let resp =
      '[ {"Location":"Киселевск","ConditionDetails":[ {"Condition":"PARR_6200 (Лимит 10000)","VesselDetails":[ {"ID":"4A58C4E5-7FDC-4E91-8608-C6D1B8D1F35D","Serial":65916,"Status":"OK","CommissioningDate":"04/02/2019","CertificationDate":"18/12/2018","LastCheckDate":"04/02/2019","Score":5,"CommissioningCount":886,"LastCheckCount":886,"CertificationCount":0,"LastAutoCounterDate":"2019-04-22 04:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"Резерв PARR_6200 (Лимит 10000)","VesselDetails":[ {"ID":"9E8F6ABD-398D-4945-A018-AFCB06BA82D1","Serial":65902,"Status":"OK","CommissioningDate":"18/12/2018","CertificationDate":"18/12/2018","LastCheckDate":"04/02/2019","Score":5,"CommissioningCount":1260,"LastCheckCount":1260,"CertificationCount":0,"LastAutoCounterDate":"2019-04-22 04:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}]}, {"Location":"Новокузнецк","ConditionDetails":[ {"Condition":"5E-C5500 (Лимит 10000)","VesselDetails":[ {"ID":"3F78FE86-9B97-482A-841D-0414158136CA","Serial":"YD50201901036","Status":"OK","CommissioningDate":"01/04/2019","CertificationDate":"Нет данных","LastCheckDate":"01/04/2019","Score":5,"CommissioningCount":764,"LastCheckCount":764,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"IKA_C2000 (Лимит 30000)","VesselDetails":[ {"ID":"EF42290A-1877-468C-8C8C-306C640311DD","Serial":100031632,"Status":"OK","CommissioningDate":"01/03/2016","CertificationDate":"03/05/2018","LastCheckDate":"23/01/2019","Score":4,"CommissioningCount":16208,"LastCheckCount":102,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"6DA845A9-6414-4AEE-894A-56AF5AB9B9CB","Serial":100063659,"Status":"OK","CommissioningDate":"31/10/2016","CertificationDate":"26/11/2018","LastCheckDate":"23/01/2019","Score":4,"CommissioningCount":14824,"LastCheckCount":4351,"CertificationCount":10601,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"30005D94-8D64-4B8D-926A-8EC7644C071C","Serial":100006814,"Status":"OK","CommissioningDate":"01/03/2016","CertificationDate":"25/06/2018","LastCheckDate":"25/06/2018","Score":4,"CommissioningCount":5526,"LastCheckCount":3752,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"LECO_AC500 (Лимит 10000)","VesselDetails":[ {"ID":"DF45B3C5-7A77-4605-9EF1-629DF4D6FFC4","Serial":6669,"Status":"OK","CommissioningDate":"14/08/2018","CertificationDate":"23/01/2019","LastCheckDate":"20/02/2019","Score":4,"CommissioningCount":7898,"LastCheckCount":4148,"CertificationCount":3542,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"421F9292-1865-4364-865C-BC1ACCB17C76","Serial":6789,"Status":"OK","CommissioningDate":"18/02/2019","CertificationDate":"18/02/2019","LastCheckDate":"26/02/2019","Score":5,"CommissioningCount":1682,"LastCheckCount":1682,"CertificationCount":0,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"608A2728-B88A-4F19-ADEB-DB83DC85117E","Serial":6790,"Status":"OK","CommissioningDate":"18/02/2019","CertificationDate":"18/02/2019","LastCheckDate":"26/02/2019","Score":5,"CommissioningCount":1084,"LastCheckCount":1084,"CertificationCount":0,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"49BE88EB-E396-48BF-A7CE-DFBB8B4E6325","Serial":6726,"Status":"OK","CommissioningDate":"29/12/2018","CertificationDate":"29/12/2018","LastCheckDate":"20/02/2019","Score":4,"CommissioningCount":4767,"LastCheckCount":3942,"CertificationCount":0,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"LECO_AC600 (Лимит 30000)","VesselDetails":[ {"ID":"89211F01-35BD-48CA-B318-6F12AC625EBB","Serial":2088,"Status":"OK","CommissioningDate":"24/05/2018","CertificationDate":"31/05/2018","LastCheckDate":"26/02/2018","Score":3,"CommissioningCount":13750,"LastCheckCount":4700,"CertificationCount":0,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"PARR_6200 (Лимит 10000)","VesselDetails":[ {"ID":"E25FD842-6720-4AC1-8472-61D5675F5ED3","Serial":6729,"Status":"OK","CommissioningDate":"20/01/2019","CertificationDate":"06/03/2019","LastCheckDate":"20/02/2019","Score":4,"CommissioningCount":2569,"LastCheckCount":2569,"CertificationCount":1353,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"15F9CD6D-DF2E-4000-A13F-CC071C5125EA","Serial":61504,"Status":"OK","CommissioningDate":"12/12/2018","CertificationDate":"12/12/2018","LastCheckDate":"31/01/2019","Score":3,"CommissioningCount":5343,"LastCheckCount":4494,"CertificationCount":0,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"45A5BCB3-2017-406A-AFA5-E8DEB0DBDCF2","Serial":61505,"Status":"OK","CommissioningDate":"12/12/2018","CertificationDate":"12/12/2018","LastCheckDate":"26/02/2019","Score":4,"CommissioningCount":6130,"LastCheckCount":3797,"CertificationCount":0,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"Выведена из эксплуатации IKA_C2000 (Лимит 30000)","VesselDetails":[ {"ID":"EA8EF8D0-C513-44BF-8D9D-B6A85754A843","Serial":100042003,"Status":"Util","CommissioningDate":"01/03/2016","CertificationDate":"02/04/2018","LastCheckDate":"26/02/2018","Score":2,"CommissioningCount":32050,"LastCheckCount":0,"LastAutoCounterDate":"2018-06-25 11:12:02","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"D9A33A7A-8D60-4F4C-AD2D-C69326615287","Serial":100024976,"Status":"Util","CommissioningDate":"01/03/2016","CertificationDate":"06/12/2018","LastCheckDate":"10/01/2018","Score":2,"CommissioningCount":28425,"LastCheckCount":0,"LastAutoCounterDate":"2019-01-07 08:30:24","LastChangedBy":"alexei_krasnoperov","onAction":"false"}]}, {"Condition":"Выведена из эксплуатации LECO_AC500 (Лимит 10000)","VesselDetails":[ {"ID":"38BE5CFC-6F18-436C-9274-556C34EBC2F0","Serial":6404,"Status":"Util","CommissioningDate":"26/03/2018","CertificationDate":"11/04/2018","LastCheckDate":"04/09/2018","Score":2,"CommissioningCount":10154,"LastCheckCount":491,"LastAutoCounterDate":"2019-01-07 08:30:43","LastChangedBy":"alexei_krasnoperov","onAction":"false"}, {"ID":"FA6D8620-2F06-4CAA-8925-64C764915DD4","Serial":57151,"Status":"Util","CommissioningDate":"06/06/2018","CertificationDate":"14/06/2018","LastCheckDate":"31/01/2019","Score":2,"CommissioningCount":13923,"LastCheckCount":902,"LastAutoCounterDate":"2019-02-18 08:30:37","LastChangedBy":"alexei_krasnoperov","onAction":"false"}, {"ID":"EBFFF848-042C-41CD-ACD4-8F2F71E796B0","Serial":6405,"Status":"Util","CommissioningDate":"26/03/2018","CertificationDate":"26/11/2018","LastCheckDate":"31/01/2019","Score":2,"CommissioningCount":10447,"LastCheckCount":4190,"LastAutoCounterDate":"2019-03-27 12:19:00","LastChangedBy":"rucoalsu","onAction":"false"}, {"ID":"9A5EEE27-288E-45F0-B11E-DA2D4CC680F2","Serial":6670,"Status":"Util","CommissioningDate":"14/08/2018","CertificationDate":"21/08/2018","LastCheckDate":"29/12/2018","Score":2,"CommissioningCount":7945,"LastCheckCount":0,"LastAutoCounterDate":"2018-12-24 08:30:57","LastChangedBy":"alexei_krasnoperov","onAction":"false"}, {"ID":"6F62BEF6-D185-4573-B352-DED2B96C4B9D","Serial":6672,"Status":"Util","CommissioningDate":"14/08/2018","CertificationDate":"21/08/2018","LastCheckDate":"31/01/2019","Score":2,"CommissioningCount":12558,"LastCheckCount":891,"LastAutoCounterDate":"2019-02-18 08:30:45","LastChangedBy":"alexei_krasnoperov","onAction":"false"}, {"ID":"5FB6FDD9-A780-44CD-BE37-F7914E4D5E1C","Serial":6671,"Status":"Util","CommissioningDate":"14/08/2018","CertificationDate":"21/08/2018","LastCheckDate":"10/01/2019","Score":2,"CommissioningCount":11274,"LastCheckCount":0,"LastAutoCounterDate":"2019-01-07 08:30:47","LastChangedBy":"alexei_krasnoperov","onAction":"false"}]}, {"Condition":"Выведена из эксплуатации PARR_6200 (Лимит 10000)","VesselDetails":[ {"ID":"1090EBAB-0363-4C6B-AA1F-1E5130079AF3","Serial":55498,"Status":"Util","CommissioningDate":"11/09/2017","CertificationDate":"16/05/2018","LastCheckDate":"25/02/2019","Score":2,"CommissioningCount":13181,"LastCheckCount":2669,"LastAutoCounterDate":"2019-03-27 12:19:00","LastChangedBy":"rucoalsu","onAction":"false"}, {"ID":"A3308F9E-8936-4950-8BF7-5612C5319674","Serial":57205,"Status":"Util","CommissioningDate":"06/06/2018","CertificationDate":"14/06/2018","LastCheckDate":"10/01/2019","Score":2,"CommissioningCount":12598,"LastCheckCount":0,"LastAutoCounterDate":"2019-01-07 08:30:39","LastChangedBy":"alexei_krasnoperov","onAction":"false"}, {"ID":"E34B21DB-6CB9-499A-81EC-E499D09CCB10","Serial":57124,"Status":"Util","CommissioningDate":"06/06/2018","CertificationDate":"14/06/2018","LastCheckDate":"31/01/2019","Score":2,"CommissioningCount":13427,"LastCheckCount":863,"LastAutoCounterDate":"2019-02-18 08:30:36","LastChangedBy":"alexei_krasnoperov","onAction":"false"}, {"ID":"15F13C96-2398-4E57-823E-E9492816CC16","Serial":55491,"Status":"Util","CommissioningDate":"11/09/2017","CertificationDate":"03/05/2018","LastCheckDate":"31/01/2019","Score":2,"CommissioningCount":13623,"LastCheckCount":822,"LastAutoCounterDate":"2019-02-18 08:30:33","LastChangedBy":"alexei_krasnoperov","onAction":"false"}]}, {"Condition":"Резерв IKA_C2000 (Лимит 30000)","VesselDetails":[ {"ID":"C3305133-B351-4882-9BED-6DC64239E038","Serial":100042005,"Status":"OK","CommissioningDate":"01/03/2016","CertificationDate":"06/03/2019","LastCheckDate":"23/01/2019","Score":3,"CommissioningCount":28921,"LastCheckCount":2337,"CertificationCount":28918,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"Резерв LECO_AC500 (ЛИМИТ 10000)","VesselDetails":[ {"ID":"163F28A5-C468-4DFA-B136-49ABC284B9F9","Serial":6760,"Status":"OK","CommissioningDate":"14/03/2019","CertificationDate":"14/03/2019","LastCheckDate":"14/03/2019","Score":5,"CommissioningCount":0,"LastCheckCount":0,"CertificationCount":0,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"8C6471B7-FDD3-4587-BE43-A75EF3484763","Serial":6748,"Status":"OK","CommissioningDate":"14/03/2019","CertificationDate":"14/03/2019","LastCheckDate":"14/03/2019","Score":5,"CommissioningCount":0,"LastCheckCount":0,"CertificationCount":0,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"Резерв LECO_AC600 (Лимит 30000)","VesselDetails":[ {"ID":"8B7C25BE-63D8-46A4-9BD0-AD87403E7251","Serial":1842,"Status":"Требуется испытание","CommissioningDate":"26/03/2018","CertificationDate":"11/04/2018","LastCheckDate":"08/10/2018","Score":3,"CommissioningCount":13575,"LastCheckCount":3990,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"94986187-BE79-4FCE-866A-BB29C285B384","Serial":2147,"Status":"OK","CommissioningDate":"29/12/2018","CertificationDate":"06/03/2019","LastCheckDate":"31/01/2019","Score":4,"CommissioningCount":3556,"LastCheckCount":1435,"CertificationCount":3473,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"Резерв PARR_6200 (Лимит 10000)","VesselDetails":[ {"ID":"CBD43CC9-0AF1-4921-A6CD-BE0B124EA232","Serial":56341,"Status":"OK","CommissioningDate":"15/12/2017","CertificationDate":"16/05/2018","LastCheckDate":"20/08/2018","Score":3,"CommissioningCount":11181,"LastCheckCount":705,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"78C37C5B-11FD-4F03-8F32-F527735AAECC","Serial":55496,"Status":"OK","CommissioningDate":"11/09/2017","CertificationDate":"03/05/2018","LastCheckDate":"27/07/2018","Score":3,"CommissioningCount":9976,"LastCheckCount":33,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"Химики","VesselDetails":[ {"ID":"28E4BF30-5D33-4AFE-ABAD-2C3DADB35517","Serial":100042006,"Status":"OK","CommissioningDate":"01/03/2016","CertificationDate":"11/04/2019","LastCheckDate":"25/07/2018","Score":4,"CommissioningCount":303,"LastCheckCount":53,"CertificationCount":252,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"BBAAEB02-F75B-41E0-8743-3C0FCAFD5278","Serial":5307,"Status":"OK","CommissioningDate":"01/03/2016","CertificationDate":"02/08/2018","LastCheckDate":"03/08/2018","Score":4,"CommissioningCount":0,"LastCheckCount":0,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"9C5C96B2-2352-4619-94AF-F5EDBBD77CB2","Serial":6046,"Status":"OK","CommissioningDate":"01/03/2016","CertificationDate":"02/08/2018","LastCheckDate":"02/08/2018","Score":4,"CommissioningCount":0,"LastCheckCount":0,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}]}, {"Location":"Черногорск","ConditionDetails":[ {"Condition":"IKA_C2000 (Лимит 30000)","VesselDetails":[ {"ID":"A5903F49-4E1C-470B-B978-F7D14E733B78","Serial":100011212,"Status":"OK","CommissioningDate":"01/07/2015","CertificationDate":"18/04/2019","LastCheckDate":"09/11/2018","Score":4,"CommissioningCount":20687,"LastCheckCount":1975,"CertificationCount":20687,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"LECO_AC500 (Лимит 10000)","VesselDetails":[ {"ID":"53592CCD-EEDC-4615-9889-41718A7DFFE7","Serial":6634,"Status":"OK","CommissioningDate":"25/06/2018","CertificationDate":"18/01/2019","LastCheckDate":"10/01/2019","Score":3,"CommissioningCount":10318,"LastCheckCount":309,"CertificationCount":10013,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"5DE5FD42-A707-460C-996E-628823EC78F7","Serial":6633,"Status":"OK","CommissioningDate":"14/08/2018","CertificationDate":"14/03/2019","LastCheckDate":"26/03/2019","Score":3,"CommissioningCount":11931,"LastCheckCount":704,"CertificationCount":11516,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"DC9F907E-1CED-4044-8095-AB0D5D5DD2B9","Serial":6750,"Status":"Требуется проверка","CommissioningDate":"18/12/2018","CertificationDate":"18/12/2018","LastCheckDate":"18/12/2018","Score":5,"CommissioningCount":5938,"LastCheckCount":5938,"CertificationCount":0,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"в резерве LECO_AC500","VesselDetails":[ {"ID":"39535642-7004-44B8-9FE8-9299A61264D8","Serial":6834,"Status":"OK","CommissioningDate":"17/04/2019","CertificationDate":"Нет данных","LastCheckDate":"17/04/2019","Score":5,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"ED4CE6D3-7777-4184-B087-DB89521DA22C","Serial":6833,"Status":"OK","CommissioningDate":"17/04/2019","CertificationDate":"Нет данных","LastCheckDate":"17/04/2019","Score":5,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}, {"Condition":"Выведена из эксплуатации LECO_AC500 (Лимит 10000)","VesselDetails":[ {"ID":"0E14CB70-D949-480B-8833-6B960E68A037","Serial":6426,"Status":"Util","CommissioningDate":"27/07/2017","CertificationDate":"03/05/2018","LastCheckDate":"09/07/2018","Score":2,"CommissioningCount":10023,"LastCheckCount":0,"LastAutoCounterDate":"2018-07-02 08:00:00","LastChangedBy":"Auto_Procedure","onAction":"false"}, {"ID":"1AA9CAFA-84A3-434C-A306-BC7DEA2C7C90","Serial":6423,"Status":"Util","CommissioningDate":"27/07/2017","CertificationDate":"05/09/2017","LastCheckDate":"15/10/2017","Score":2,"CommissioningCount":9671,"LastCheckCount":0,"LastAutoCounterDate":"2018-10-15 08:30:45","LastChangedBy":"alexei_krasnoperov","onAction":"false"}, {"ID":"BBCF9481-2A7A-49CA-B89C-F234D078B73E","Serial":6396,"Status":"Util","CommissioningDate":"12/03/2018","CertificationDate":"25/06/2018","LastCheckDate":"29/12/2018","Score":2,"CommissioningCount":10188,"LastCheckCount":0,"LastAutoCounterDate":"2018-12-28 19:49:37","LastChangedBy":"alexei_krasnoperov","onAction":"false"}]}, {"Condition":"Резерв IKA_C2000 (Лимит 30000)","VesselDetails":[ {"ID":"2C9CB1CA-6453-44E8-9A5A-F176FF39E564","Serial":100028150,"Status":"OK","CommissioningDate":"01/07/2015","CertificationDate":"18/02/2019","LastCheckDate":"20/02/2019","Score":4,"CommissioningCount":21034,"LastCheckCount":1392,"CertificationCount":20022,"LastAutoCounterDate":"2019-04-22 08:31:00","LastChangedBy":"Auto_Procedure","onAction":"false"}]}]}]';

    let myDataParse = JSON.parse(resp);
    commit('loadVessels', myDataParse);
  },
  Table_UpdateVessel: ({ commit }, payload) => {
    $.ajax({
      url: './GetPageText.ashx?Id=@Nav_Backend@',
      type: 'POST',
      dataType: 'json',
      data: { PARAM2: 'Vessels_GetData', unid: payload.unid },
      complete: function(resp) {
        var myDataParse = JSON.parse(resp.response);
        /*MEMO: Мод на поиск и удаление старого значения, в случае изменения глобальной инфы по сосуду - состояния или локации*/

        if (typeof payload.mode !== 'undefined') {
          if (typeof payload.unid !== 'undefined') {
            commit('MUTATION_TABLE_REMOVE_OLD', payload.unid);
          }
        }
        /*MEMO: Берём ответ от сервера чтобы можно было обновлять данные в таблице вне зависимости откуда пришёл запрос - для обновления счётчика или параметров*/
        if (typeof myDataParse[0] !== 'undefined') {
          commit('MUTATION_TABLE_UPDATE', myDataParse[0]);
        }
      },
      error: function(resp) {
        commit('SET_ERROR', resp.statusText);
      },
    });
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
