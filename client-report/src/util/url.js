// Copyright (C) 2012-present, The Authors. This program is free software: you can redistribute it and/or  modify it under the terms of the GNU Affero General Public License, version 3, as published by the Free Software Foundation. This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Affero General Public License for more details. You should have received a copy of the GNU Affero General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.

var prod = "https://pol.is/";
var preprod = "https://preprod.pol.is/";
var embed = "https://embed.pol.is/";
var survey = "https://survey.pol.is/";
var polisio = "https://www.polis.io/";
var localhost = "http://localhost:5000/";
var localhost5002 = "http://localhost:5002/";
var localhost5010 = "http://localhost:5010/";

// DF customization - add custom localdomain
var polislocal = "https://polis.local/";
// DF customization - add custom test domain
var polisDfTest = "https://polis-test.digifinland.dev/";
// DF customization - add custom gke test domain
var polisDfTestGke = "https://polis-test-gke.digifinland.dev/";
// DF customization - add custom gke prod domain
var polisDfProdGke = "https://polis.digifinland.fi/";


var urlPrefix = prod;
if (document.domain.indexOf("preprod") >= 0) {
    urlPrefix = preprod;
}
if (document.domain.indexOf("embed") >= 0) {
    urlPrefix = embed;
}
if (document.domain.indexOf("survey") >= 0) {
    urlPrefix = survey;
}
if (document.domain.indexOf("polis.io") >= 0) {
    urlPrefix = polisio;
}
if ((-1 === document.domain.indexOf("pol.is")) && (-1 === document.domain.indexOf("polis.io"))) {
    urlPrefix = localhost;
}

if (document.domain === "localhost" && document.location.port === "5002") {
  urlPrefix = localhost5002;
}

if (document.domain === "localhost" && document.location.port === "5010") {
  urlPrefix = localhost5010;
}

if (0 === document.domain.indexOf("192.168") || (new RegExp(/\.(ssl|n)ip\.io/)).test(document.domain) ) {
  urlPrefix = "http://" + document.location.hostname + ":" + document.location.port + "/";
}

// DF customization - add custom localdomain
if (document.domain.indexOf("polis.local") >= 0) {
  urlPrefix = polislocal;
}
// DF customization - add custom testdomain
if (document.domain.indexOf("polis-test.digifinland.dev") >= 0) {
  urlPrefix = polisDfTest;
}
// DF customization - add custom gke testdomain
if (document.domain.indexOf("polis-test-gke.digifinland.dev") >= 0) {
  urlPrefix = polisDfTestGke;
}
// DF customization - add custom gke testdomain
if (document.domain.indexOf("polis.digifinland.fi") >= 0) {
  urlPrefix = polisDfProdGke;
}


function isPreprod() {
  return urlPrefix === preprod;
}

function isLocalhost() {
  //return urlPrefix === localhost || urlPrefix === localhost8000;
  return urlPrefix === localhost;
}
export default {
  urlPrefix: urlPrefix,
  isPreprod: isPreprod,
  isLocalhost: isLocalhost
};