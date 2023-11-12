using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Ix
{
    public  class IxException : Exception 
    {
        public string ComputerName { get; set; }
        public DateTime Time { get; set; }
        public int Severity { get; set; }

        public IxException(string message) : base(message) { }

        public IxException(string message, Exception innerException, string computerName) : base(message, innerException) {
            ComputerName = computerName;
            Time = DateTime.Now;
        }

        public IxException(string message, Exception innerException, string computerName, int severity) : this(message, innerException, computerName)
        {
            Severity = severity;
        }
    }
}
