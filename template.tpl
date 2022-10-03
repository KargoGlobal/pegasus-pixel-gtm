___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "categories": ["ANALYTICS", "ADVERTISING", "ATTRIBUTION"],
  "version": 1,
  "securityGroups": [],
  "displayName": "Kargo Pegasus Pixel",
  "brand": {
    "id": "brand_dummy",
    "displayName": "Custom Template"
  },
  "description": "Kargo Pegasus Pixel to provide advertising analytics and consumer insights",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "partnerId",
    "displayName": "Partner ID",
    "simpleValueType": true,
    "help": "Please reach out to Kargo to learn more",
    "notSetText": "Please enter partner ID provided by Kargo",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  },
  {
    "type": "TEXT",
    "name": "eventName",
    "displayName": "Event Name",
    "simpleValueType": true,
    "defaultValue": "PageView",
    "help": "Please insert a value if tracking a non-pageview event",
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

// Require APIs
const callInWindow = require('callInWindow');
const copyFromWindow = require('copyFromWindow');
const injectScript = require('injectScript');
const log = require('logToConsole');
const setInWindow = require('setInWindow');

const partnerId = data.partnerId;
const eventName = data.eventName;

const evtJsUrl = "https://pixel.prod.pegasus.kargo.com/"+partnerId+"/pixel-payload.js";
let extKrgPgs = copyFromWindow('krg_pgs') || {};

// Skip kds initialization if it's already loaded
if (extKrgPgs.version) {
  callInWindow('krg_pgs', 'init', partnerId);
  callInWindow('krg_pgs', 'track', eventName);
  return;
}

let krg_pgs = function () {
  // If needed, check for external script readiness
  if (krg_pgs.isInitialized && !krg_pgs.isReady) {
    extKrgPgs = copyFromWindow('krg_pgs');
    if (extKrgPgs && extKrgPgs.callMethod) {
      krg_pgs.isReady = true;
    }
  }

  if (extKrgPgs.callMethod) {
    // Relay calls to external kds
    callInWindow('krg_pgs.relayCallMethod', arguments);
  } else {
    // Queue events when external script isn't loaded
    krg_pgs.queue.push(arguments);
  }
};

// Define kds properties
krg_pgs.version = '1.0';
krg_pgs.isInitialized = false;
krg_pgs.isReady = false;
krg_pgs.queue = [];

// Queue the initial events
krg_pgs('init', partnerId);
krg_pgs('track', eventName);
krg_pgs.isInitialized = true;

// Make kds visible outside
const overrideExisting = false;
setInWindow('krg_pgs', krg_pgs, overrideExisting);

// Inject external JS
injectScript(evtJsUrl, data.gtmOnSuccess, data.gtmOnFailure, evtJsUrl);

// Call data.gtmOnSuccess when the tag is finished.
data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "krg_pgs"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "inject_script",
        "versionId": "1"
      },
      "param": [
        {
          "key": "urls",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 1,
                "string": "https://pixel.prod.pegasus.kargo.com/*"
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios:
- name: Init
  code: |-
    const mockData = {
      partnerId: "ffffffff",
      eventName: "PageView"
    };

    // Call runCode to run the template's code.
    runCode(mockData);

    // Verify that the tag finished successfully.
    assertApi('gtmOnSuccess').wasCalled();


___NOTES___

Created on 10/3/2022, 8:59:24 PM
