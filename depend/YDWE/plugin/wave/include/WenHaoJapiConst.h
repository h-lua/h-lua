    #define KEY_MOUSE_MOVE     0x200 //����ƶ� �����������е�3������ �뿪�������е�4������
    #define KEY_MOUSE_LEFT_UP      0x201 //����������  TextureAddEvent���е�3������
    #define KEY_MOUSE_LEFT_DOWN    0x202 //����������  TextureAddEvent���е�4������
    #define KEY_MOUSE_RIGHT_UP     0x204 //����Ҽ�����  TextureAddEvent���е�3������
    #define KEY_MOUSE_RIGHT_DOWN   0x205 //����Ҽ�����  TextureAddEvent���е�4������
    //���̼�λ 
    //���¼�λ ���� ���� TextureAddEvent �ĵ�3������
    //���� ���� ��4������
    //��������ּ�
    #define KEY_0        0x30
    #define KEY_1        0x31
    #define KEY_2        0x32
    #define KEY_3        0x33
    #define KEY_4        0x34
    #define KEY_5        0x35
    #define KEY_6        0x36
    #define KEY_7        0x37
    #define KEY_8        0x38
    #define KEY_9        0x39
    
    //С���� ���ּ�
    #define KEY_NUM_0         0x60
    #define KEY_NUM_1         0x61
    #define KEY_NUM_2         0x62
    #define KEY_NUM_3         0x63
    #define KEY_NUM_4         0x64
    #define KEY_NUM_5         0x65
    #define KEY_NUM_6         0x66
    #define KEY_NUM_7         0x67
    #define KEY_NUM_8         0x68
    #define KEY_NUM_9         0x69
    
    #define KEY_A        'A'
    #define KEY_B        'B'
    #define KEY_C        'C'
    #define KEY_D        'D'
    #define KEY_E        'E'
    #define KEY_F        'F'
    #define KEY_G        'G'
    #define KEY_H        'H'
    #define KEY_I        'I'
    #define KEY_J        'J'
    #define KEY_K        'K'
    #define KEY_L        'L'
    #define KEY_M        'M'
    #define KEY_N        'N'
    #define KEY_O        'O'
    #define KEY_P        'P'
    #define KEY_Q        'Q'
    #define KEY_R        'R'
    #define KEY_S        'S'
    #define KEY_T        'T'
    #define KEY_U        'U'
    #define KEY_V        'V'
    #define KEY_W        'W'
    #define KEY_X        'X'
    #define KEY_Y        'Y'
    #define KEY_Z        'Z'
    
    #define KEY_F1            0x70
    #define KEY_F2            0x71
    #define KEY_F3            0x72
    #define KEY_F4            0x73
    #define KEY_F5            0x74
    #define KEY_F6            0x75
    #define KEY_F7            0x76
    #define KEY_F8            0x77
    #define KEY_F9            0x78
    #define KEY_F10           0x79
    #define KEY_F11           0x7a
    #define KEY_F12           0x7b
    
    
    #define KEY_TAB           0x9
    #define KEY_ENTER         0xd //�س���
    #define KEY_SHLFT         0x10
    #define KEY_CTRL          0x11
    #define KEY_ALT           0x12
    #define KEY_ESC           0x1b
    #define KEY_SPACE         0x20 //�ո��
    
    #define KEY_SLASH         0xbf // ��б�� \\ 
    #define KEY_BACKSLASH     0xdc //��б�� //
    
    //ħ�ް汾 ��GetGameVersion ����ȡ��ǰ�汾 ���Ա����¾���汾������Ӧ����
    #define version_124b   6374
    #define version_124e   6387
    #define version_126    6401  
    #define version_127a   7000
    #define version_127b   7085
    #define version_128a   7205
    
    
    //#define YDWE_OBJECT_TYPE_ABILITY    0
    //#define YDWE_OBJECT_TYPE_BUFF      1
    //#define YDWE_OBJECT_TYPE_UNIT      2
    //#define YDWE_OBJECT_TYPE_ITEM      3
    //#define YDWE_OBJECT_TYPE_UPGRADE    4
    //#define YDWE_OBJECT_TYPE_DOODAD    5
    //#define YDWE_OBJECT_TYPE_DESTRUCTABLE   6
    
    //-----------ģ������------------------
    #define CHAT_RECIPIENT_ALL    0    // [������]
    #define CHAT_RECIPIENT_ALLIES      1    // [����]
    #define CHAT_RECIPIENT_OBSERVERS   2    // [�ۿ���]
    #define CHAT_RECIPIENT_REFEREES    2    // [����]
    #define CHAT_RECIPIENT_PRIVATE     3    // [˽�˵�]
    
    //---------������������---------------
    
    ///<summary>��ȴʱ��</summary>
    #define ABILITY_STATE_COOLDOWN 1

    ///<summary>Ŀ������</summary>
    #define ABILITY_DATA_TARGS 100

    ///<summary>ʩ��ʱ��</summary>
    #define ABILITY_DATA_CAST 101

    ///<summary>����ʱ��</summary>
    #define ABILITY_DATA_DUR 102

    ///<summary>����ʱ��</summary>
    #define ABILITY_DATA_HERODUR 103

    ///<summary>ħ������</summary>
    #define ABILITY_DATA_COST 104

    ///<summary>ʩ�ż��</summary>
    #define ABILITY_DATA_COOL 105

    ///<summary>Ӱ������</summary>
    #define ABILITY_DATA_AREA 106

    ///<summary>ʩ������</summary>
    #define ABILITY_DATA_RNG 107

    ///<summary>����A</summary>
    #define ABILITY_DATA_DATA_A 108

    ///<summary>����B</summary>
    #define ABILITY_DATA_DATA_B 109

    ///<summary>����C</summary>
    #define ABILITY_DATA_DATA_C 110

    ///<summary>����D</summary>
    #define ABILITY_DATA_DATA_D 111

    ///<summary>����E</summary>
    #define ABILITY_DATA_DATA_E 112

    ///<summary>����F</summary>
    #define ABILITY_DATA_DATA_F 113

    ///<summary>����G</summary>
    #define ABILITY_DATA_DATA_G 114

    ///<summary>����H</summary>
    #define ABILITY_DATA_DATA_H 115

    ///<summary>����I</summary>
    #define ABILITY_DATA_DATA_I 116

    ///<summary>��λ����</summary>
    #define ABILITY_DATA_UNITID 117

    ///<summary>�ȼ�</summary>
    #define ABILITY_DATA_HOTKET 200

    ///<summary>�ر��ȼ�</summary>
    #define ABILITY_DATA_UNHOTKET 201

    ///<summary>ѧϰ�ȼ�</summary>
    #define ABILITY_DATA_RESEARCH_HOTKEY 202

    ///<summary>����</summary>
    #define ABILITY_DATA_NAME 203

    ///<summary>ͼ��</summary>
    #define ABILITY_DATA_ART 204

    ///<summary>Ŀ��Ч��</summary>
    #define ABILITY_DATA_TARGET_ART 205

    ///<summary>ʩ����Ч��</summary>
    #define ABILITY_DATA_CASTER_ART 206

    ///<summary>Ŀ���Ч��</summary>
    #define ABILITY_DATA_EFFECT_ART 207

    ///<summary>����Ч��</summary>
    #define ABILITY_DATA_AREAEFFECT_ART 208

    ///<summary>Ͷ����</summary>
    #define ABILITY_DATA_MISSILE_ART 209

    ///<summary>����Ч��</summary>
    #define ABILITY_DATA_SPECIAL_ART 210

    ///<summary>����Ч��</summary>
    #define ABILITY_DATA_LIGHTNING_EFFECT 211

    ///<summary>buff��ʾ</summary>
    #define ABILITY_DATA_BUFF_TIP 212

    ///<summary>buff��ʾ</summary>
    #define ABILITY_DATA_BUFF_UBERTIP 213

    ///<summary>ѧϰ��ʾ</summary>
    #define ABILITY_DATA_RESEARCH_TIP 214

    ///<summary>��ʾ</summary>
    #define ABILITY_DATA_TIP 215

    ///<summary>�ر���ʾ</summary>
    #define ABILITY_DATA_UNTIP 216

    ///<summary>ѧϰ��ʾ</summary>
    #define ABILITY_DATA_RESEARCH_UBERTIP 217

    ///<summary>��ʾ</summary>
    #define ABILITY_DATA_UBERTIP 218

    ///<summary>�ر���ʾ</summary>
    #define ABILITY_DATA_UNUBERTIP 219

    #define ABILITY_DATA_UNART 220
    
    #define ABILITY_DATA_RESEARCH_ART 221

    //----------��Ʒ��������----------------------

    ///<summary>��Ʒͼ��</summary>
    #define ITEM_DATA_ART 1

    ///<summary>��Ʒ��ʾ</summary>
    #define ITEM_DATA_TIP 2

    ///<summary>��Ʒ��չ��ʾ</summary>
    #define ITEM_DATA_UBERTIP 3

    ///<summary>��Ʒ����</summary>
    #define ITEM_DATA_NAME 4

    ///<summary>��Ʒ˵��</summary>
    #define ITEM_DATA_DESCRIPTION 5


    //------------��λ��������--------------
    ///<summary>����1 �˺���������</summary>
    #define UNIT_STATE_ATTACK1_DAMAGE_DICE 0x10

    ///<summary>����1 �˺���������</summary>
    #define UNIT_STATE_ATTACK1_DAMAGE_SIDE 0x11

    ///<summary>����1 �����˺�</summary>
    #define UNIT_STATE_ATTACK1_DAMAGE_BASE 0x12

    ///<summary>����1 ��������</summary>
    #define UNIT_STATE_ATTACK1_DAMAGE_BONUS 0x13

    ///<summary>����1 ��С�˺�</summary>
    #define UNIT_STATE_ATTACK1_DAMAGE_MIN 0x14

    ///<summary>����1 ����˺�</summary>
    #define UNIT_STATE_ATTACK1_DAMAGE_MAX 0x15

    ///<summary>����1 ȫ�˺���Χ</summary>
    #define UNIT_STATE_ATTACK1_RANGE 0x16

    ///<summary>װ��</summary>
    #define UNIT_STATE_ARMOR 0x20

    // attack 1 attribute adds
    ///<summary>����1 �˺�˥������</summary>
    #define UNIT_STATE_ATTACK1_DAMAGE_LOSS_FACTOR 0x21

    ///<summary>����1 ��������</summary>
    #define UNIT_STATE_ATTACK1_WEAPON_SOUND 0x22

    ///<summary>����1 ��������</summary>
    #define UNIT_STATE_ATTACK1_ATTACK_TYPE 0x23

    ///<summary>����1 ���Ŀ����</summary>
    #define UNIT_STATE_ATTACK1_MAX_TARGETS 0x24

    ///<summary>����1 �������</summary>
    #define UNIT_STATE_ATTACK1_INTERVAL 0x25

    ///<summary>����1 �����ӳ�/summary>
    #define UNIT_STATE_ATTACK1_INITIAL_DELAY 0x26

    ///<summary>����1 ���仡��</summary>
    #define UNIT_STATE_ATTACK1_BACK_SWING 0x28

    ///<summary>����1 ������Χ����</summary>
    #define UNIT_STATE_ATTACK1_RANGE_BUFFER 0x27

    ///<summary>����1 Ŀ������</summary>
    #define UNIT_STATE_ATTACK1_TARGET_TYPES 0x29

    ///<summary>����1 ��������</summary>
    #define UNIT_STATE_ATTACK1_SPILL_DIST 0x56

    ///<summary>����1 �����뾶</summary>
    #define UNIT_STATE_ATTACK1_SPILL_RADIUS 0x57

    ///<summary>����1 ��������</summary>
    #define UNIT_STATE_ATTACK1_WEAPON_TYPE 0x58

    // attack 2 attributes (sorted in a sequencial order based on memory address)
    ///<summary>����2 �˺���������</summary>
    #define UNIT_STATE_ATTACK2_DAMAGE_DICE 0x30

    ///<summary>����2 �˺���������</summary>
    #define UNIT_STATE_ATTACK2_DAMAGE_SIDE 0x31

    ///<summary>����2 �����˺�</summary>
    #define UNIT_STATE_ATTACK2_DAMAGE_BASE 0x32

    ///<summary>����2 ��������</summary>
    #define UNIT_STATE_ATTACK2_DAMAGE_BONUS 0x33

    ///<summary>����2 �˺�˥������</summary>
    #define UNIT_STATE_ATTACK2_DAMAGE_LOSS_FACTOR 0x34

    ///<summary>����2 ��������</summary>
    #define UNIT_STATE_ATTACK2_WEAPON_SOUND 0x35

    ///<summary>����2 ��������</summary>
    #define UNIT_STATE_ATTACK2_ATTACK_TYPE 0x36

    ///<summary>����2 ���Ŀ����</summary>
    #define UNIT_STATE_ATTACK2_MAX_TARGETS 0x37

    ///<summary>����2 �������</summary>
    #define UNIT_STATE_ATTACK2_INTERVAL 0x38

    ///<summary>����2 �����ӳ�</summary>
    #define UNIT_STATE_ATTACK2_INITIAL_DELAY 0x39

    ///<summary>����2 ������Χ</summary>
    #define UNIT_STATE_ATTACK2_RANGE 0x40

    ///<summary>����2 ��������</summary>
    #define UNIT_STATE_ATTACK2_RANGE_BUFFER 0x41

    ///<summary>����2 ��С�˺�</summary>
    #define UNIT_STATE_ATTACK2_DAMAGE_MIN 0x42

    ///<summary>����2 ����˺�</summary>
    #define UNIT_STATE_ATTACK2_DAMAGE_MAX 0x43

    ///<summary>����2 ���仡��</summary>
    #define UNIT_STATE_ATTACK2_BACK_SWING 0x44

    ///<summary>����2 Ŀ����������</summary>
    #define UNIT_STATE_ATTACK2_TARGET_TYPES 0x45

    ///<summary>����2 ��������</summary>
    #define UNIT_STATE_ATTACK2_SPILL_DIST 0x46

    ///<summary>����2 �����뾶</summary>
    #define UNIT_STATE_ATTACK2_SPILL_RADIUS 0x47

    ///<summary>����2 ��������</summary>
    #define UNIT_STATE_ATTACK2_WEAPON_TYPE 0x59

    ///<summary>װ������</summary>
    #define UNIT_STATE_ARMOR_TYPE 0x50

    #define UNIT_STATE_RATE_OF_FIRE 0x51 // global attack rate of unit, work on both attacks
    #define UNIT_STATE_ACQUISITION_RANGE 0x52 // how far the unit will automatically look for targets
    #define UNIT_STATE_LIFE_REGEN 0x53
    #define UNIT_STATE_MANA_REGEN 0x54

    #define UNIT_STATE_MIN_RANGE 0x55
    #define UNIT_STATE_AS_TARGET_TYPE 0x60
    #define UNIT_STATE_TYPE 0x61
