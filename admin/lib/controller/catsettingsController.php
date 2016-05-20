<?php

class catsettingsController extends viewcontroller {
    private $msg = '';

    public function __construct() {
        parent::__construct();
       	parent::makeTemplate("catsettings.html");
    }
    
    public function doAction(){
      if (array_key_exists("do",$_POST)) {
        if ($_POST['do'] == 'update') {
          $cmd = "scripts/configure-web-server-config.perl";
          $cmd .= " -itpenabled ".($_POST["itpenabled"] ? 1 : 0); 
          $cmd .= " -srenabled ".($_POST["srenabled"] ? 1 : 0); 
          $cmd .= " -biconcorenabled ".($_POST["biconcorenabled"] ? 1 : 0); 
          $cmd .= " -hidecontributions ".($_POST["hidecontributions"] ? 1 : 0); 
          $cmd .= " -floatpredictions ".($_POST["floatpredictions"] ? 1 : 0); 
          $cmd .= " -translationoptions ".($_POST["translationoptions"] ? 1 : 0); 
          $cmd .= " -allowchangevisualizationoptions ".($_POST["allowchangevisualizationoptions"] ? 1 : 0); 
          $cmd .= " -itpdraftonly ".($_POST["itpdraftonly"] ? 1 : 0); 
          $cmd .= " -displayMouseAlign ".($_POST["displayMouseAlign"] ? 1 : 0); 
          $cmd .= " -displayCaretAlign ".($_POST["displayCaretAlign"] ? 1 : 0); 
          $cmd .= " -displayShadeOffTranslatedSource ".($_POST["displayShadeOffTranslatedSource"] ? 1 : 0); 
          $cmd .= " -displayconfidences ".($_POST["displayconfidences"] ? 1 : 0); 
          $cmd .= " -highlightValidated ".($_POST["highlightValidated"] ? 1 : 0); 
          $cmd .= " -highlightPrefix ".($_POST["highlightPrefix"] ? 1 : 0); 
          $cmd .= " -highlightSuffix ".($_POST["highlightSuffix"] ? 1 : 0); 
          $cmd .= " -highlightLastValidated ".($_POST["highlightLastValidated"] ? 1 : 0); 
          $cmd .= " -limitSuffixLength ".($_POST["limitSuffixLength"] ? 1 : 0); 
          exec($cmd);
          $this->msg = "Updated.";
        }
      }
    }


    public function setTemplateVars() {
      $current = file("/opt/casmacat/web-server/inc/config.ini");
      foreach($current as $line) {
        if (preg_match("/itpenabled = (\d)/",$line,$match)) {
          $this->template->itpenabled = $match[1];
        }
        if (preg_match("/srenabled = (\d)/",$line,$match)) {
          $this->template->srenabled = $match[1];
        }
        if (preg_match("/biconcorenabled = (\d)/",$line,$match)) {
          $this->template->biconcorenabled = $match[1];
        }
        if (preg_match("/hidecontributions = (\d)/",$line,$match)) {
          $this->template->hidecontributions = $match[1];
        }
        if (preg_match("/floatpredictions = (\d)/",$line,$match)) {
          $this->template->floatpredictions = $match[1];
        }
        if (preg_match("/translationoptions = (\d)/",$line,$match)) {
          $this->template->translationoptions = $match[1];
        }
        if (preg_match("/allowchangevisualizationoptions = (\d)/",$line,$match)) {
          $this->template->allowchangevisualizationoptions = $match[1];
        }
        if (preg_match("/itpdraftonly = (\d)/",$line,$match)) {
          $this->template->itpdraftonly = $match[1];
        }
        if (preg_match("/displayMouseAlign = (\d)/",$line,$match)) {
          $this->template->displayMouseAlign = $match[1];
        }
        if (preg_match("/displayCaretAlign = (\d)/",$line,$match)) {
          $this->template->displayCaretAlign = $match[1];
        }
        if (preg_match("/displayShadeOffTranslatedSource = (\d)/",$line,$match)) {
          $this->template->displayShadeOffTranslatedSource = $match[1];
        }
        if (preg_match("/displayconfidences = (\d)/",$line,$match)) {
          $this->template->displayconfidences = $match[1];
        }
        if (preg_match("/highlightValidated = (\d)/",$line,$match)) {
          $this->template->highlightValidated = $match[1];
        }
        if (preg_match("/highlightPrefix = (\d)/",$line,$match)) {
          $this->template->highlightPrefix = $match[1];
        }
        if (preg_match("/highlightSuffix = (\d)/",$line,$match)) {
          $this->template->highlightSuffix = $match[1];
        }
        if (preg_match("/highlightLastValidated = (\d)/",$line,$match)) {
          $this->template->highlightLastValidated = $match[1];
        }
        if (preg_match("/limitSuffixLength = (\d)/",$line,$match)) {
          $this->template->limitSuffixLength = $match[1];
        }
      } 
      $this->template->msg = $this->msg;
    }
}
?>
