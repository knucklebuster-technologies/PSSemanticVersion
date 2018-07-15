using System;

namespace PSSemanticVersion
{
    public class Version
    {
        public UInt64 Major { get; set; }
        public UInt64 Minor { get; set; }
        public UInt64 Patch { get; set; }
        public UInt64 Build { get; set; }
        public String Tag { get; set; }
        public Boolean LeadingV { get; set; }
        public String ParsedString { get; set; }

        public Version() {
            this.LeadingV = false;
        }

        public Version(UInt64 major, UInt64 minor, UInt64 patch, UInt64 build, string tag)
        {
            this.Major = major;
            this.Minor = minor;
            this.Patch = patch;
            this.Build = build;
            this.Tag = tag;
            this.LeadingV = false;
        }
    }
}