<div style="
	display: block;
	border-top: 1px dashed black;
	margin-top: 1ex;
	margin-right: 11.5em;
	text-align: right;
">
<div align="left">
<?=$DBInfo->counter->pageCounter($this->page->name)?>
</div>
<?
# Processing Instruction�� #action ���ǰ� ������,
# $this->actions�� ���ԵǾ��ִ��� Ȯ���غ���,
# ������ �װ��� ����Ʈ�Ѵ�.
    if ($this->pi['#action'] && !in_array($this->pi['#action'],$this->actions)){
      list($act,$txt)=explode(" ",$this->pi['#action'],2);
      print $this->link_to("?action=$act",$txt);
    }
# txt ��ſ� ������ �������� �ִ��� �մϴ�.
?>
Best viewed with 
<?=$this->link_tag("Mozilla","","Mozilla","")?>
 latest.
Powered by 
<?=$this->link_tag("MoniWiki","","MoniWiki","title='MoniWiki'")?>.
</div>
