// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue';
import App from './App';
import { store } from './store/store';

Vue.config.productionTip = false;
Vue.component('fld-textarea', {
  template:
    '<div class="FiCon">' +
    '<textarea class="fld" row="1" :required="isRequired" name="Field" :id="inputId" v-model="inputVal" @focus="toggleLabel($event)" @blur="toggleLabel($event)" @keyup="searchData($event)"></textarea>' +
    '<div class="likePlaceholder " v-text="rusDesc"></div>' +
    '<div class="borderPseudo"></div>' +
    '</div>',
  props: ['rusDesc', 'value', 'inputId', 'isRequired'],
  methods: {
    toggleLabel (e) {
      likeLabelV(e);
      textareaAutoGrow();
    },
    searchData (e) {}
  },
  computed: {
    inputVal: {
      get () {
        return this.value;
      },
      set (value) {
        this.$emit('input', value);
      }
    }
  },
  created () {
    const component = this;
    this.handler = function (e) {
      component.$emit('keyup', e);
    };
    window.addEventListener('keyup', this.handler);
  },
  updated () {
    var thisEl = document.getElementById(this.inputId);
    likeLabelOnCreateV(thisEl);
    textareaAutoGrow();
  },
  mounted () {
    var thisEl = document.getElementById(this.inputId);
    likeLabelOnCreateV(thisEl);
    textareaAutoGrow();
  }
});

Vue.component('select-block', {
  template:
    '<div class="FiCon">' +
    '<select class="fld" name="Field" :id="selectId" v-model="currentItem" :required="isRequired" @focus="toggleLabel($event)" @blur="toggleLabel($event)">' +
    '<option :selected="true">{{currentItem}}</option>' +
    '<option></option>' +
    '<option v-for="itemType in itemTypesPars" :value="itemType" >{{ itemType }}</option>' +
    '</select>' +
    '<div class="likePlaceholder " v-text="rusDesc"></div>' +
    '<div class="borderPseudo"></div>' +
    '</div>',
  props: ['rusDesc', 'value', 'selectId', 'itemTypes', 'isRequired'],
  methods: {
    toggleLabel (e) {
      likeLabelV(e);
    }
  },
  computed: {
    currentItem: {
      get: function () {
        return this.value;
      },
      set: function (value) {
        if (typeof this.itemTypesPars !== 'undefined') {
          this.$emit('input', value);
        }
      }
    },
    itemTypesPars () {
      if (
        typeof this.itemTypes !==
        'undefined' /* && this.itemTypes.length !== 0 */
      ) {
        let itemTypesTemp = this.itemTypes;
        itemTypesTemp = itemTypesTemp
          .substring(0, itemTypesTemp.length - 1)
          .split(';');
        return itemTypesTemp;
      } else {
        return '';
      }
    }
  },
  updated: function () {
    var thisEl = document.getElementById(this.selectId);
    likeLabelOnCreateV(thisEl);
  },
  mounted () {
    var thisEl = document.getElementById(this.selectId);
    likeLabelOnCreateV(thisEl);
  }
});

Vue.component('fld-input', {
  template:
    '<div class="FiCon">' +
    '<input class="fld" :required="isRequired" name="Field" :id="inputId" :readonly="isReadonly" v-model="inputVal" @focus="toggleLabel($event)" @blur="toggleLabel($event)" @keyup="searchData($event)"/>' +
    '<div class="likePlaceholder" v-text="rusDesc"></div>' +
    '<div class="borderPseudo"></div>' +
    '</div >',
  props: ['rusDesc', 'value', 'inputId', 'isReadonly', 'isRequired'],
  methods: {
    toggleLabel (e) {
      likeLabelV(e);
    },
    searchData (e) {}
  },
  computed: {
    inputVal: {
      get: function () {
        return this.value;
      },
      set: function (value) {
        this.$emit('input', value);
      }
    }
  },
  created: function () {
    const component = this;
    this.handler = function (e) {
      component.$emit('keyup', e);
    };
    window.addEventListener('keyup', this.handler);
  },
  updated: function () {
    var thisEl = document.getElementById(this.inputId);
    likeLabelOnCreateV(thisEl);
  },
  mounted () {
    var thisEl = document.getElementById(this.inputId);
    likeLabelOnCreateV(thisEl);
  }
});

Vue.component('date-picker', {
  template:
    '<div class="FiCon">' +
    '<input autocomplete="off" v-model="inputVal" class="fld" name ="Field" :id ="inputId" required @focus="toggleLabel($event)" @blur="toggleLabel($event)" />' +
    '<div class="likePlaceholder " v-text="rusDesc"></div>' +
    '<div class="borderPseudo"></div>' +
    '</div>',
  props: ['dateFormat', 'value', 'inputId', 'rusDesc'],

  methods: {
    toggleLabel (e) {
      likeLabelV(e);
    }
  },
  computed: {
    inputVal: {
      get: function () {
        return this.value;
      },
      set: function (value) {
        this.$emit('input', value);
      }
    }
  },

  mounted: function () {
    var self = this;
    var thisEl = document.getElementById(self.inputId);
    // eslint-disable-next-line no-undef
    $(thisEl).datepicker({
      dateFormat: 'dd/mm/yy' /* this.dateFormat */,
      firstDay: 1,
      changeMonth: true,
      changeYear: true,
      onSelect: function (date) {
        self.$emit('input', date);
        if (date !== '') {
          likeLabelOnCreateV(thisEl);
        }
      }
    });

    likeLabelOnCreateV(thisEl);
    // eslint-disable-next-line no-undef
    $(thisEl).removeClass('hasDatepicker');
  },
  updated: function () {
    var self = this;
    var thisEl = document.getElementById(self.inputId);
    likeLabelOnCreateV(thisEl);
  },

  beforeDestroy: function () {
    // eslint-disable-next-line no-undef
    $(this.$el)
      .datepicker('hide')
      .datepicker('destroy');
  }
});

function textareaAutoGrow () {
  var inputs = document.getElementsByTagName('textarea');
  for (var i = 0; i < inputs.length; i += 1) {
    autoGrow(inputs[i]);
  }
}

function likeLabelV (e) {
  e.target.nextSibling.classList.add('likeLabel');
  if (e.target.value === '' && e.type === 'blur') {
    e.target.nextSibling.classList.remove('likeLabel');
  }
  textareaAutoGrow();
  e.target.parentNode.lastElementChild.classList.toggle('borderPseudoLine');
}

function likeLabelOnCreateV (elem) {
  if (elem.value !== '') {
    elem.nextSibling.classList.add('likeLabel');
  }
}

function autoGrow (element) {
  if (element.value.length > 1) {
    element.style.height = element.scrollHeight + 'px';
    if (element.scrollHeight === 0) {
      element.style.height = '24px';
    }
  }
}
/* eslint-disable no-new */
new Vue({
  el: '#app',
  store,
  components: { App },
  template: '<App/>'
});
