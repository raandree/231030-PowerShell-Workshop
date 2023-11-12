using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Car
{
    public class Car
    {
        public string Manufacturer { get; set; }
        public string Model { get; set; }
        public string Color { get; set; }
        public int Speed { get; set; }

        public static int MaxSpeed = 250;

        public void Accelerate(int km)
        {
            int newSpeed = Speed + km;

            if (newSpeed > MaxSpeed)
            {
                throw new Exception("Running too fast.");
            }
            else
            {
                Speed = newSpeed;
            }
        }
    }
}
