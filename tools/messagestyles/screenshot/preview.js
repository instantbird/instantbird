/* ***** BEGIN LICENSE BLOCK *****
 * Version: MPL 1.1/GPL 2.0/LGPL 2.1
 *
 * The contents of this file are subject to the Mozilla Public License Version
 * 1.1 (the "License"); you may not use this file except in compliance with
 * the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS" basis,
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License
 * for the specific language governing rights and limitations under the
 * License.
 *
 * The Original Code is the Instantbird messenging client
 *
 * The Initial Developer of the Original Code is
 * Florian QUEZE <florian@instantbird.org>.
 * Portions created by the Initial Developer are Copyright (C) 2009
 * the Initial Developer. All Rights Reserved.
 *
 * Contributor(s):
 *
 * Alternatively, the contents of this file may be used under the terms of
 * either the GNU General Public License Version 2 or later (the "GPL"), or
 * the GNU Lesser General Public License Version 2.1 or later (the "LGPL"),
 * in which case the provisions of the GPL or the LGPL are applicable instead
 * of those above. If you wish to allow use of your version of this file only
 * under the terms of either the GPL or the LGPL, and not to allow others to
 * use your version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the notice
 * and other provisions required by the GPL or the LGPL. If you do not delete
 * the provisions above, a recipient may use your version of this file under
 * the terms of any one of the MPL, the GPL or the LGPL.
 *
 * ***** END LICENSE BLOCK ***** */

const Ci = Components.interfaces;

function Conversation(aName, aIsChat)
{
  this.name = aName;
  this.isChat = aIsChat;
}
Conversation.prototype = {
  QueryInterface: function(aIid) {
    if (aIid.equals(Components.interfaces.nsISupports) ||
        aIid.equals(Components.interfaces.purpleIConversation) ||
        aIid.equals(this.isChat ? Ci.purpleIConvChat : Ci.purpleIConvIM))
      return this;

    throw Components.results.NS_ERROR_NO_INTERFACE;
  },

  addObserver: function(aObserver) { },
  removeObserver: function() { },
  close: function() null,
  sendTyping: function() null,

  get title() this.name,
  account: {protocol: {name: "XMPP"}, name: "florian@instantbird.org/instantbird"},
  buddy: null,
  typingStage: Ci.purpleIConvIM.NO_TYPING,
  topic: "Fake Conversation"
};

function Message(aTime, aWho, aMessage, aObject)
{
  this.time = aTime;
  this.who = aWho;
  this.alias = aWho;
  this.message = aMessage;
  this.originalMessage = aMessage;

  if (aObject)
    for (let i in aObject)
      this[i] = aObject[i];
}
Message.prototype = {
  QueryInterface: function(aIid) {
    if (aIid.equals(Components.interfaces.nsISupports) ||
        aIid.equals(Components.interfaces.purpleIMessage))
      return this;
    throw Components.results.NS_ERROR_NO_INTERFACE;
  },

  reset: function m_reset() {
    this.message = this.originalMessage;
  },
  conversation: null,
  outgoing: false,
  incoming: false,
  system: false,
  autoResponse: false,
  containsNick: false,
  noLog: false,
  error: false,
  delayed: false,
  noFormat: false,
  containsImages: false,
  notification: false,
  noLinkification: false
};

const messagesStylePrefBranch = "messenger.options.messagesStyle.";
const themePref = "theme";
const variantPref = "variant";

var previewObserver = {
  load: function() {
    previewObserver.env = Components.classes["@mozilla.org/process/environment;1"]
                         .getService(Components.interfaces.nsIEnvironment);
    previewObserver.prefs =
      Components.classes["@mozilla.org/preferences-service;1"]
                .getService(Components.interfaces.nsIPrefService)
                .getBranch(messagesStylePrefBranch);

    previewObserver.initialTheme = previewObserver.prefs.getCharPref(themePref);
    previewObserver.initialVariant = previewObserver.prefs.getCharPref(variantPref);
    previewObserver.currentTheme = previewObserver.env.get("THEME") || "default";
    previewObserver.prefs.setCharPref(themePref, previewObserver.currentTheme);

    dump(previewObserver.currentTheme+"\n");
    previewObserver.browser = document.getElementById("browser");

    let conv = new Conversation("Florian");

    let makeDate = function(aDateString) {
      let array = aDateString.split(":");
      return (new Date(2009, 11, 8, array[0], array[1], array[2])) / 1000;
    };
    let messages = [
      new Message(makeDate("9:42:00"), "Florian", "hey, Instantbird can now use Adium message styles!", {outgoing: true, conversation: conv}),
      new Message(makeDate("9:42:22"), "Quentin", "oh, really?", {incoming: true, conversation: conv}),
      new Message(makeDate("9:42:38"), "Florian", "Yes", {outgoing: true, conversation: conv}),
      new Message(makeDate("9:42:59"), "Florian", "But there are some differences in the way themes are handled by Instantbird and Adium, so it is possible that some themes will appear broken in Instantbird.", {outgoing: true, conversation: conv}),
      new Message(makeDate("9:43:17"), "Quentin", "Is this caused by bugs in the themes?", {incoming: true, conversation: conv}),
      new Message(makeDate("9:43:48"), "Florian", "Not necessarily. So if something looks like it's broken, don't blame the original author, who may not be responsible for it.", {outgoing: true, conversation: conv}),
      new Message(makeDate("9:45:22"), "Quentin", "ok, I have to go, see you.", {incoming: true, conversation: conv}),
      new Message(makeDate("9:45:29"), "Quentin", "Quentin has gone away.", {system: true, conversation: conv})
    ];
    conv.messages = messages;
    previewObserver.conv = conv;
    previewObserver._previewImages = [];

    previewObserver.getVariants();
    dump(previewObserver.variants.toSource() + "\n");
    previewObserver.nextVariant();
  },

  nextVariant: function() {
    var variant = this.variants.shift();
    if (!variant) {
      this.prefs.setCharPref(themePref, this.initialTheme);
      this.prefs.setCharPref(variantPref, this.initialVariant);
      window.close();
      return;
    }

    this.currentVariant = variant;
    this.prefs.setCharPref(variantPref, this.currentVariant.name);
    this.reloadPreview();
  },

  getVariants: function() {
    this.theme = getCurrentTheme();
    let variants = getThemeVariants(this.theme);

    let defaultVariant = "";
    if (("DefaultVariant" in this.theme.metadata) &&
        variants.indexOf(this.theme.metadata.DefaultVariant) != -1)
      defaultVariant = this.theme.metadata.DefaultVariant;

    let defaultText = defaultVariant;
    if (!defaultText && ("DisplayNameForNoVariant" in this.theme.metadata))
      defaultText = this.theme.metadata.DisplayNameForNoVariant;
    if (!defaultText)
      defaultText = "Default variant";

    this.variants = [{name: defaultVariant || "default", caption: defaultText}];
    variants.forEach(function(aVariantName) {
      if (aVariantName != defaultVariant)
        this.variants.push({name: aVariantName, caption: aVariantName});
    }, this);
    if (this.variants.length > 5)
      this.variants.length = 5;
  },

  reloadPreview: function() {
    this.conv.messages.forEach(function (m) { m.reset(); });
    this.browser.init(this.conv);
    Components.classes["@mozilla.org/observer-service;1"]
              .getService(Components.interfaces.nsIObserverService)
              .addObserver(this, "conversation-loaded", false);
  },

  observe: function(aSubject, aTopic, aData) {
    if (aTopic != "conversation-loaded" || aSubject != this.browser)
      return;

    // Display all queued messages. Use a timeout so that message text
    // modifiers can be added with observers for this notification.
    setTimeout(function(aSelf) {
      aSelf.conv.messages.forEach(aSelf.browser.appendMessage, aSelf.browser);
      setTimeout(aSelf.saveScreenshotAndContinue, 1000);
    }, 0, this);

    Components.classes["@mozilla.org/observer-service;1"]
              .getService(Components.interfaces.nsIObserverService)
              .removeObserver(this, "conversation-loaded");
  },

  _lastScreenshot: 0,
  saveScreenshotAndContinue: function() {
    var dataURI = previewObserver.takeScreenshot();
    if (previewObserver._previewImages.indexOf(dataURI.spec) == -1) {
      previewObserver._previewImages.push(dataURI.spec);
      var path = (previewObserver.env.get("SAVE_PATH") || ".") +
        "/Screenshot-" + previewObserver.currentTheme + "-" +
        (++previewObserver._lastScreenshot) + "-" +
        previewObserver.currentVariant.caption + ".png";
      previewObserver.saveURI(dataURI, path);
    }
    else
      dump("discarding identical screenshot!\n");
    previewObserver.nextVariant();
  },

  takeScreenshot: function() {
    var canvas = document.getElementById("canvas");
    var ctx = canvas.getContext("2d");
    var win = document.getElementById("browser").contentWindow;
    canvas.width = win.innerWidth;
    canvas.height = win.innerHeight;
    ctx.drawWindow(win, win.scrollX, win.scrollY,
                   win.innerWidth, win.innerHeight,
                   "rgb(255,255,255)");

    // create a data url from the canvas and then create URIs of the source and targets
    return Components.classes["@mozilla.org/network/io-service;1"]
                       .getService(Components.interfaces.nsIIOService)
                       .newURI(canvas.toDataURL("image/png", ""), "UTF8", null);
  },

  saveURI: function(aURI, destFile) {
    // convert string filepath to an nsIFile
    var file = Components.classes["@mozilla.org/file/local;1"]
                         .createInstance(Components.interfaces.nsILocalFile);
    file.initWithPath(destFile);

    const nsIWebBrowserPersist = Components.interfaces.nsIWebBrowserPersist;
    var persist = Components.classes["@mozilla.org/embedding/browser/nsWebBrowserPersist;1"]
                            .createInstance(nsIWebBrowserPersist);

    persist.persistFlags = nsIWebBrowserPersist.PERSIST_FLAGS_REPLACE_EXISTING_FILES |
                           nsIWebBrowserPersist.PERSIST_FLAGS_AUTODETECT_APPLY_CONVERSION;
    persist.saveURI(aURI, null, null, null, null, file);
  }
};

this.addEventListener("load", previewObserver.load, false);
