package co.FlashPunk.DuckHunt.Stages
{
	import co.FlashPunk.DuckHunt.Entities.Crosshair;
	import co.FlashPunk.DuckHunt.Entities.Dog;
	import co.FlashPunk.DuckHunt.Entities.Duck;
	
	import flashx.textLayout.elements.OverflowPolicy;
	
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	
	public class MainStage extends World
	{
		private var _hasCrosshair:Boolean = false;
		public function MainStage()
		{
			add(new Duck());
			add(new Crosshair());
		}
		
		
	}
}