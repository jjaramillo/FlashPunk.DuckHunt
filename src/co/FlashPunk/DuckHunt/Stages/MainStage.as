package co.FlashPunk.DuckHunt.Stages
{
	import co.FlashPunk.DuckHunt.Entities.Dog;
	
	import net.flashpunk.World;
	
	public class MainStage extends World
	{
		public function MainStage()
		{
			add(new Dog());
		}
	}
}